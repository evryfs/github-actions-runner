[![Docker Repository on Quay](https://quay.io/repository/evryfs/github-actions-runner/status "Docker Repository on Quay")](https://quay.io/repository/evryfs/github-actions-runner)


Note: The master tag uses the virtual-environments setup from GHA, which is not in use by this project anymore - thus that image is no longer updated - the last tag will be 20230409.1
Use the myoung34-derivative image instead!


# github-actions-runner

Image for containerized github [actions runner](https://github.com/actions/runner).
Also see [the Kubernetes operator](https://github.com/evryfs/github-actions-runner-operator/).

## Usage

In order to try mimic as much as possible what is done in the [github-hosted runner](https://docs.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners) project, we try to reuse their installer scripts.

So this image will allow you to use the [installers](https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/installers) from the official [virtual-environments](https://github.com/actions/virtual-environments) project.

But since the original project has been designed to be executed on real VM instead of Docker containers, some scripts can fail,
like the ones who try to install `snap` packages (since `snap` can't run on Docker).

Here you can find the [list of available installers](https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/installers).

## Configurations

Github Actions Runner can be configured dynamically using env vars with the following prefix `ACTIONS_RUNNER_INPUT_`.

At the time of writing the configuration options are:

```
Config Options:
 --unattended           Disable interactive prompts for missing arguments. Defaults will be used for missing options
 --url string           Repository to add the runner to. Required if unattended
 --token string         Registration token. Required if unattended
 --name string          Name of the runner to configure (default 29b09814cbea)
 --runnergroup string   Name of the runner group to add this runner to (defaults to the default runner group)
 --labels string        Extra labels in addition to the default: 'self-hosted,Linux,X64'
 --work string          Relative runner work directory (default _work)
 --replace              Replace any existing runner with the same name (default false)
```

So if you want set custom labels you just need to export this env var: `ACTIONS_RUNNER_INPUT_LABELS=foobar, 1234`

### Install packages

To run an installer script and its packages you can just simply run `install-from-virtual-env <installer-file-name>`. You can find
some examples on the Dockerfile.
