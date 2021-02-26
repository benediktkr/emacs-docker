# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmaster&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/master/)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/benediktkr/emacs?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/benediktkr/emacs?sort=date&style=flat-square)

Builds the latest stable emacs in a docker image, packages it as `.deb` and `.tar.gz` and then publishe a [docker image to Docker Hub](https://hub.docker.com/r/benediktkr/emacs-docker/) with emacs installed:

```
docker run --rm -it benediktkr/emacs:27.1
```


The `.deb` package is uploaded to [apt.sudo.is](https://apt.sudo.is).


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
