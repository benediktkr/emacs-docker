# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmain&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/main/)
![Stable Version](https://img.shields.io/docker/v/benediktkr/emacs/latest?sort=semver&label=stable&color=blue&style=flat-square)
![Nightly Version](https://img.shields.io/docker/v/benediktkr/emacs-nightly/latest?sort=semver&color=yellow&label=nightly&style=flat-square)
![matrix](https://img.shields.io/static/v1?label=matrix&message=%23darkroom:sudo.is&color=purple&style=flat-square)


Builds both the latest version from `master` in the repo (called
`nightly` here), and looks for the newest tag (release) and builds
that.

Builds are packaged as `.deb` and `.tar.gz`, and are also published as
[docker images](https://git.sudo.is/ben/emacs-docker/packages?q=&type=container):

 * [`emacs:latest`](https://git.sudo.is/ben/-/packages/container/emacs/): the latest stable build
 * [`emacs-nightly:latest`](https://git.sudo.is/ben/-/packages/container/emacs-nightly/): the latest nightly build, built from the `master` branch of the upstream emacs repo


```shell
# to get the latest stable version
docker run --rm -it git.sudo.is/ben/emacs:latest

# to get the latest nightly build
docker run --rm -it git.sudo.is/ben/emacs-nightly:latest
```

The docker images are also pushed to dockerhub:

```shell
docker pull benediktkr/emacs:latest
docker pull benediktkr/emacs-nightly:latest
```

The `.deb` packages are uploaded to [apt.sudo.is](https://apt.sudo.is).

```
wget -q -O - https://apt.sudo.is/KEY.gpg | sudo apt-key add -
echo "deb https://apt.sudo.is/ /" > /etc/apt/sources.list.d/apt.sudo.is.list
apt-get update

apt-get install emacs
```


Dockerfiles for other docker images:

 * `git/Dockerfile`: clone the emacs repo with git and build emacs.
 * `amzn/Dockerfile`: custom Amazon Linux 2 build
 * `alpine/Dockerfile`: alpine has up-to-date emacs versions.
