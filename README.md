

⚠️ **Deprecation Notice** ⚠️

This GitHub Action (`platformsh-deploy-action`) is now deprecated and will no longer be maintained or receive updates. We recommend using the new [Platform.sh Action](https://github.com/axelerant/platformsh-action) for all future deployments and integrations.

## Migration Instructions

To migrate to the new action, Edit your workflow YAML file(s) and follow these steps:

1. Checkout repository code

  ```yaml
  - name: Check out repository code
    uses: actions/checkout@v4
    with:
      fetch-depth: 0
  ```
2. **Replace the old action**: replace any references to `axelerant/platformsh-deploy-action` with `axelerant/platformsh-action`.

## Example

**Old Configuration:**

  ```yaml
    - name: Deploy to Platform.sh
      uses: axelerant/platformsh-deploy-action@v1
      with:
        project-id: 'project-id'
        cli-token: ${{ secrets.PlatformCliToken }}
        ssh-private-key: ${{ secrets.PlatformSshKey }}
        php-version: 8.1
        force-push: true
  ```

**New Configuration:**

```yaml
- name: Check out repository code
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
- name: Deploy to platform.sh
  uses: axelerant/platformsh-action@v1
  with:
    action: 'deploy'
    project-id: 'project-id'
    cli-token: ${{ secrets.PLATFORMSH_CLI_TOKEN }}
    ssh-private-key: ${{ secrets.PlatformSshKey }}
    force-push: true
```

# Platform.sh Deploy action

This is a composite action designed to simplify deployment to platform.sh. One of the main reasons to write this was to avoid a basic mistake with checking out the repository. The popular Github action `actions/checkout` does a shallow clone by default which can sometimes break the site. This action does a full clone and sets up PHP as well before installing the CLI.

## Inputs

### `project-id`

The project ID on platform.sh. You can find this using the CLI or the web console.

### `cli-token`

A token to access platform.sh API. See instructions on [platform.sh docs](https://docs.platform.sh/development/cli/api-tokens.html).

### `ssh-private-key` (optional)

The platform.sh CLI generates a temporary certificate for use for deployment. However, you may still choose to provide a private key that lets you push via git. Create a specialized key used _only_ for deployment and use Github secrets to keep your key safe.

### `php-version`

The PHP version to use. This is directly passed to [`shivammathur/setup-php`](https://github.com/marketplace/actions/setup-php-action). Default: `8.0`.

### `force-push`

An option to force push changes to the project repository on Platform.sh. Use with caution as force push overrides your commit history.

### `environment-name`

The name of the platform.sh instance on which to act. Default: The current branch name.

## Outputs

No outputs.

## Example usage

```yaml
uses: axelerant/platformsh-deploy-action@v1
with:
  project-id: ${{ secrets.PlatformProjectId }}
  cli-token: ${{ secrets.PlatformCliToken }}
  ssh-private-key: ${{ secrets.PlatformSshKey }}
  php-version: 8.1
  force-push: true
```
