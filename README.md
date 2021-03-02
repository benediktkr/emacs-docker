# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmaster&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/master/)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/benediktkr/emacs?sort=semver&style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/benediktkr/emacs?sort=date&style=flat-square)


Builds both the latest version from `master` in the repo, and looks for the newest tag (release) and builds that. Builds are packaged as `.deb` and `.tar.gz` and then publishe a [docker image to Docker Hub](https://hub.docker.com/r/benediktkr/emacs/) with emacs installed.

The `latest` tag follows the master branch builds.

```
docker run --rm -it benediktkr/emacs:27.1

docker run --rm -it benedikt/emacs:latest
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
 * `amzn/Dockerfile`: custom Amazon Linux 1 docker build
 * `alpine/Dockerfile`: alpine has up-to-date emacs versions.
