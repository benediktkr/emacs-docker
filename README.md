# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmain&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/main/)
[![git](https://www.sudo.is/readmes/git.sudo.is-ben.svg)](https://git.sudo.is/ben/emacs-docker)
[![github](https://www.sudo.is/readmes/github-benediktkr.svg)](https://github.com/benediktkr/emacs-docker)
[![matrix](https://www.sudo.is/readmes/matrix-ben-sudo.is.svg)](https://matrix.to/#/@ben:sudo.is)
[![matrix-channel](https://www.sudo.is/readmes/matrix-darkroom-sudo-is.svg)](https://matrix.to/#/#darkroom:sudo.is)
[![Stable Version](https://img.shields.io/docker/v/benediktkr/emacs/latest?sort=semver&label=stable&color=blue&style=flat-square)]()
[![Nightly Version](https://img.shields.io/docker/v/benediktkr/emacs-nightly/latest?sort=semver&color=yellow&label=nightly&style=flat-square)]()
[![BSD-3-Clause-No-Military-License](https://www.sudo.is/readmes/license-BSD-blue.svg)](LICENSE)


Builds the latest stable version (last git tag) of the [upstream emacs repo mirrored at github](https://github.com/emacs-mirror/emacs)
(pulled from the [`git.sudo.is/mirrors/emacs` mirror](https://git.sudo.is/mirrors/emacs)). The builds are packaged [as debian/ubuntu packages](debian/package.sh),
and docker images, and only target `amd64`.

# Builds

Debian/Ubuntu `.deb` packages (for `amd64`) can be downloaded from the following repos:

* [`git.sudo.is/ben/-packages/debian/emacs`](https://git.sudo.is/ben/-/packages/debian/emacs)
    ```shell
    sudo curl https://git.sudo.is/api/packages/ben/debian/repository.key -o /etc/apt/trusted.gpg.d/gitea-ben.asc
    echo "deb [arch=amd64] https://git.sudo.is/api/packages/ben/debian all main" | sudo tee -a /etc/apt/sources.list.d/gitea.list
    sudo apt update

    apt-get install emacs
    ```

* [`apt.sudo.is`](https://apt.sudo.is)

    ```shell
    wget -q -O - https://apt.sudo.is/KEY.gpg | sudo apt-key add -
    echo "deb https://apt.sudo.is/ /" > /etc/apt/sources.list.d/apt.sudo.is.list
    apt-get update

    apt-get install emacs
    ```

Docker images:

  * [`git.sudo.is/ben/emacs:latest`](https://git.sudo.is/ben/-/packages/container/emacs)
    ```shell
    docker run --pull --rm -it benediktkr/emacs:latest
    ```

  * [`benediktkr/emacs:latest`](https://hub.docker.com/r/benediktkr/emacs)
    ```shell
    docker run --pull --rm -it git.sudo.is/ben/emacs:latest
    ```

Tarballs are also available:

  * [`git.sudo.is/ben/-packages/generic/emacs`](https://git.sudo.is/ben/-/packages/generic/emacs/)


# ⚠️  Current status -- Archival notice

This occasionally breaks, and personally I am switching over to `vim` [anyway](https://web.archive.org/web/20190918054433/https://arstechnica.com/tech-policy/2019/09/richard-stallman-leaves-mit-after-controversial-remarks-on-rape/),
so this repo and it's builds will be archived at some point in the near future. I am not aware of my builds having
gained any sort of widespread use other than myself, but if someone wants to take over maintaining current emacs
builds for Debian/Ubuntu, feel free to fork this repo (if you let me know, i'll link to the new maintainer before
archiving).

_The `nightly` builds are no longer provided. Though the code is still there if you want to build it_

_Jenkins cro job has been disabled._

# Repo and mirrors

Dockerfiles for other docker images:

 * `git/Dockerfile`: clone the emacs repo with git and build emacs.
 * `amzn/Dockerfile`: custom Amazon Linux 2 build
 * `alpine/Dockerfile`: alpine has up-to-date emacs versions.
