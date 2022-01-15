# Platform.sh Deploy action

This is a composite action designed to simplify deployment to platform.sh. One of the main reasons to write this was to avoid a basic mistake with checking out the repository. The popular Github action `actions/checkout` does a shallow clone by default which can sometimes break the site. This action does a full clone and sets up PHP as well before installing the CLI.

## Inputs

### `project-id`

The project ID on platform.sh. You can find this using the CLI or the web console.

### `cli-token`

A token to access platform.sh API. See instructions on [platform.sh docs](https://docs.platform.sh/development/cli/api-tokens.html).

### `ssh-private-key`

Apart from the token, the action also needs a private key to use to be able to push via git (the CLI uses git internally). Create a specialized key used _only_ for deployment and use Github secrets to keep your key safe.

### `php-version`

The PHP version to use. This is directly passed to [`shivammathur/setup-php`](https://github.com/marketplace/actions/setup-php-action). Default: `8.0`.

## Outputs

No outputs.

## Example usage

```yaml
uses: axelerant/platformsh-deploy-action@v1
with:
  project-id: ${{ secrets.PlatformProjectId }}
  cli-token: ${{ secrets.PlatformCliToken }}
  ssh-private-key: ${{ secrets.PlatformSshKey }}
  php-version: 7.4
```
