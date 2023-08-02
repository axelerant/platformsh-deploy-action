#!/usr/bin/env php
<?php declare(strict_types=1);

namespace Platformsh\Scripts;

$cliCommand = 'platform';

log("Fetching the list of regions from the API...");

// Read the existing known_hosts file.
$existing_known_hosts = [];
$e_filename = __DIR__ . '/../known_hosts';
if (\file_exists($e_filename)) {
    $known_hosts_lines = \file($e_filename, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

    // Build an associative array based on domain key.
    foreach ($known_hosts_lines as $line) {
        [$e_domain, ] = \explode(' ', trim($line));
        $existing_known_hosts[trim($e_domain)] = $line;
    }
}

$json = run($cliCommand . ' api:curl ' . escapeshellarg('/regions?filter[private]=0'));
$regions = $json ? \json_decode($json, true) : [];
if (!$regions || empty($regions['regions'])) {
    log("\nUnable to read regions from the API.");
    exit(1);
}

log(\count($regions['regions']) . " region(s) found\n");

$domains = [];
foreach ($regions['regions'] as $region) {
    $domain = \parse_url($region['endpoint'], PHP_URL_HOST);
    if (!$domain) {
        log("Failed to parse hostname for region: " . $region['id']);
        continue;
    }
    $domains[] = $domain;
}

sortDomains($domains);

$known_hosts = [];

$prefixes = ['git.', 'ssh.'];
$count = \count($domains) * \count($prefixes);
$i = 1;
foreach ($domains as $domain) {
    foreach ($prefixes as $prefix) {
        log(\sprintf("%02d/%02d Scanning %s%s", $i, $count, $prefix, $domain));
        if ($output = run('ssh-keyscan ' . \escapeshellarg($prefix . $domain) . ' 2>/dev/null')) {
            $known_hosts[] = trim($output);
        }
        elseif (isset($existing_known_hosts[$prefix . $domain])) {
            // Use the existing record as fallback if ssh-keyscan fails.
            $known_hosts[] = $existing_known_hosts[$prefix . $domain];
        }
        $i++;
    }
}

$filename = __DIR__ . '/known_hosts';

if (!\file_put_contents($filename, \implode("\n", $known_hosts) . "\n")) {
    log("Failed to write to file: $filename");
    exit(1);
}

log("\nDone. Review any change(s) carefully.");
exit(0);

/**
 * Logs a message to the terminal.
 */
function log(string $msg, $newline = true): void
{
    \fputs(STDERR, $msg . ($newline ? "\n" : ''));
}

/**
 * Runs a command and returns its output while logging errors.
 */
function run(string $cmd): string
{
    \exec($cmd, $output, $result_code);
    if ($result_code !== 0) {
        log("The command returned an error code ($result_code): $cmd");
        return '';
    }
    return \implode("\n", $output);
}

/**
 * Sorts a list of region domains.
 */
function sortDomains(array &$regions): bool
{
    return \usort($regions, 'Platformsh\Scripts\compareDomains');
}

/**
 * Compares region domains for natural sorting.
 */
function compareDomains(string $regionA, string $regionB): int
{
    if (\strpos($regionA, '.') && \strpos($regionB, '.')) {
        $partsA = \explode('.', $regionA, 2);
        $partsB = \explode('.', $regionB, 2);
        return (\strnatcasecmp($partsA[1], $partsB[1]) * 10) + \strnatcasecmp($partsA[0], $partsB[0]);
    }
    return \strnatcasecmp($regionA, $regionB);
}
