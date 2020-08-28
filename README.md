[![Docker Repository on Quay](https://quay.io/repository/evryfs/github-actions-runner/status "Docker Repository on Quay")](https://quay.io/repository/evryfs/github-actions-runner)

# github-actions-runner

Image for containerized github [actions runner](https://github.com/actions/runner).
Also see [the Kubernetes operator](https://github.com/evryfs/github-actions-runner-operator/).

## Usage

In order to try mimin as much as possible the (github-hosted runner)[https://docs.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners], we try to reuse as much as possible of their installer scripts.

This image allows to use the (installers)[https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/installer] from the official [virtual-environments](https://github.com/actions/virtual-environments) project.
The project has been designed to be executed on real VM instead of Docker containers and in some case the scripts can fail,
like the ones who try to install `snap` packages.

Here you can find the (installers)[https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/installer] here.

### Install packages

To run an installer and its packages you can just simply run `install-from-virtual-env <installer-file-name>` you can find
some examples on the Dockerfile.

