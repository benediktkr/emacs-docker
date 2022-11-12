def version = ""
def debname = "emacs"
def dockername = "emacs"
def amzn_prefix = "/home/benedikt.kristinsson/.local"
def timer = currentBuild.getBuildCauses()[0]["shortDescription"].matches("Started by timer")
def skip_build = false

def get_version() {
    return sh(
        script: "grep AC_INIT configure.ac | awk -F',' '{print \$2}' | tr -d '[] '",
        returnStdout: true
    ).trim()
}


def build_exists(String version) {
    return fileExists(
        "${env.JENKINS_HOME}/artifacts/emacs_${version}.deb"
    )
}

pipeline {
    agent any
    parameters {
        string(name: 'build_mode', defaultValue: 'stable')
    }
    triggers {
        parameterizedCron('@daily %build_mode=stable')
    }
    options {
        timestamps()
        ansiColor("xterm")
        disableConcurrentBuilds()
        skipDefaultCheckout()
        buildDiscarder(
            logRotator(
                // daysToKeepStr: '15',
                // artifactDaysToKeepStr: '15',
                numToKeepStr:'30',
                artifactNumToKeepStr: '1'
            )
        )
    }
    stages {
        stage('checkout') {
            steps{
                checkout scm

                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'refs/heads/master']],
                    extensions: [[
                        $class: 'RelativeTargetDirectory',
                        relativeTargetDir: 'emacs-src'
                    ]],
                    doGenerateSubmoduleConfigurations: false,
                    // extensions: [[$class: 'CloneOption',
                    //               depth: 1, noTags: false, shallow: true]],
                    userRemoteConfigs: [[
                        url: 'https://git.sudo.is/mirrors/emacs.git'
                    ]],
                    //branches: [[name: "refs/tags/emacs-${env.VERSION}"]]
                    //branches: [[name: "master"]]
                ])

                dir('emacs-src') {
                    script {
                        // current branch should be 'master'
                        sh "git --no-pager show --oneline -s"

                        // in master branch,
                        //   git describe --tags --abbrev=0
                        //   emacs-27.1
                        //
                        // in emacs-27 branch:
                        //   git describe --tags --abbrev=0
                        //   emacs-27.1.91
                        //
                        //
                        // the latest tag that is reachable from master
                        // seems to be the latest stable release.
                        //
                        // to get the latest minor relase instead,
                        // check out the emacs-$MAJOR branch (not tag)


                        def latest_tag = sh(
                            script: "git for-each-ref --sort=-creatordate --format='%(refname:lstrip=2)' 'refs/tags/emacs-*' --count 1",
                            returnStdout: true
                        )
                        echo "latest tag reachable from master: ${latest_tag}"

                        if (params.build_mode == "nightly") {
                            // no `git checkout`, jenkins has already
                            // checked out master from origin.
                            //
                            debname = "emacs-nightly"
                            dockername = "emacs-nightly"
                        }
                        else if (params.build_mode == "stable") {
                            def ref = "refs/tags/" + latest_tag
                            sh "git checkout -f ${ref}"

                            debname = "emacs"
                            dockername = "emacs"
                        }
                        else if (params.build_mode.startsWith("emacs-")) {
                            def ref = "refs/tags/" + params.build_mode
                            sh "git checkout -f ${ref}"

                            debname = "emacs"
                            dockername = "emacs"
                        }
                        else {
                            error("unkonwn build_mode param")
                        }

                        version = get_version()
                        currentBuild.displayName +=  " - ${debname} v${version}"
                        currentBuild.description = params.build_mode
                        echo "version: ${version}"

                        if (timer && build_exists(version)) {
                            echo "build for ${version} exists"
                            echo "skipping building steps"
                            skip_build = true
                        }
                    }
                }
            }
        }

        stage ('deb: build emacs') {
            when { expression { skip_build  == false } }
            steps {
                sh "docker build --pull -f debian/Dockerfile --build-arg VERSION=${version} --build-arg DEBNAME=${debname} --target builder -t ${dockername}:builder-${version} ."
                sh "docker container create --name emacs_debian_builder ${dockername}:builder-${version}"

                dir('dist/') {
                    sh "docker container cp emacs_debian_builder:/emacs/debian/ ."
                }
            }
        }
        stage('deb: container') {
            when { expression { skip_build == false } }
            steps {
                sh "docker build --pull -f debian/Dockerfile --build-arg VERSION=${version} --build-arg DEBNAME=${debname} --target final -t ${dockername}:${version} ."

            }
        }
        stage('amzn') {
            when {
                expression { skip_build  == false }
                // dont do nightly builds of czemacs
                expression { params.build_mode == "stable" }
            }
            steps {
                sh "docker build -f amzn/Dockerfile --build-arg PREFIX=${amzn_prefix} --build-arg VERSION=${version} -t emacs-amzn:${version}-amzn ."
                sh "docker container create --name emacs_amzn_builder emacs-amzn:${version}-amzn "
                sh "docker container cp emacs_amzn_builder:/emacs/amzn/ dist/"
            }
        }

    }

    post {
        success {
            script {
                if ( !skip_build ) {
                    archiveArtifacts(
                        artifacts: 'dist/*/*.tar.gz,dist/debian/*.deb',
                        fingerprint: true
                    )

                    sh "cp -v dist/*/*.tar.gz ${env.JENKINS_HOME}/artifacts"
                    sh "cp -v dist/debian/*.deb ${env.JENKINS_HOME}/artifacts"

                    build(
                        job: "/utils/apt",
                        wait: true,
                        propagate: true,
                        parameters: [[
                            $class: 'StringParameterValue',
                            name: 'filename',
                            value: "${debname}_${version}_amd64.deb"
                        ]]
                    )

                    // git.sudo.is
                    //  latest
                    sh "docker tag ${dockername}:${version} git.sudo.is/ben/${dockername}:latest"
                    sh "docker push git.sudo.is/ben/${dockername}:latest"
                    //  version (looks better in gitea if its pushed last)
                    sh "docker tag ${dockername}:${version} git.sudo.is/ben/${dockername}:${version}"
                    sh "docker push git.sudo.is/ben/${dockername}:${version}"

                    // dockerhub
                    //  version
                    sh "docker tag ${dockername}:${version} benediktkr/${dockername}:${version}"
                    sh "docker push benediktkr/${dockername}:${version}"
                    //  latest (looks better on dockerhub if pushed last)
                    sh "docker tag ${dockername}:${version} benediktkr/${dockername}:latest"
                    sh "docker push benediktkr/${dockername}:latest"

                    withCredentials([string(credentialsId: 'gitea-user-token', variable: 'SECRET')]) {
                        def curl = "curl --user ben:${SECRET}"
                        def gitea = "https://git.sudo.is/api/packages/ben/generic"
                        sh "du -sh dist/debian/${debname}-${version}.tar.gz"
                        sh "${curl} --upload-file dist/debian/${debname}-${version}.tar.gz ${gitea}/${debname}/${version}/${debname}-${version}.tar.gz"
                        // currently only one file allowed in gitea v1.17.0: https://github.com/go-gitea/gitea/pull/20661
                        //sh "${curl} --upload-file dist/debian/${debname}_${version}_amd64.deb ${gitea}/${debname}/${version}/${debname}_${version}_amd64.deb"
                    }

                }

            }
        }
        cleanup {

            script {
                if (! skip_build ) {
                    sh "rm -v dist/*/*.tar.gz || true"
                    sh "rm -v dist/debian/*.deb || true"
                    sh "docker container rm emacs_debian_builder || true"
                    sh "docker container rm emacs_amzn_builder || true"
                }
            }
        }

        // always {
        //     cleanWs(
        //         deleteDirs: true,
        //         patterns: [[pattern: 'emacs-src', type: 'EXCLUDE']],
        //         disableDeferredWipeout: true,
        //         notFailBuild: true
        //     )
        // }
    }
}
