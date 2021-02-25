def version = ""
def amzn_prefix = "/home/bkristinsson/.local"
def timer = currentBuild.getBuildCauses()[0]["shortDescription"].matches("Started by timer")
def skip_build = false

pipeline {
    agent any
    triggers {
        cron('@daily')
    }
    options {
        timestamps()
        ansiColor("xterm")
        disableConcurrentBuilds()
        skipDefaultCheckout()
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
                    branches: [[name: "master"]]
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
                            script: 'git describe --tags --abbrev=0',
                            returnStdout: true
                        )
                        version = latest_tag.split('-')[1].trim()

                        sh "git checkout refs/tags/${latest_tag}"
                        sh "git --no-pager show --oneline -s"

                        def build_exists = fileExists(
                            "${env.JENKINS_HOME}/artifacts/emacs-${version}.tar.gz"
                        )
                        skip_build = (timer && build_exists)

                        echo "latest tag reachable from master: ${latest_tag}"
                        echo "build for ${version} exists: ${build_exists}"
                        echo "started by timer: ${timer}"
                        echo "skip building: ${skip_build}"
                    }
                }
            }
        }

        stage('amzn') {
            when { expression { skip_build  == false } }
            steps {
                sh "docker build -f amzn/Dockerfile --build-arg PREFIX=${amzn_prefix} --build-arg VERSION=${version} -t emacs-amzn:${version}-amzn ."
                sh "docker container create --name emacs_amzn_builder emacs-amzn:${version}-amzn "
                sh "docker container cp emacs_amzn_builder:/emacs/amzn/ dist/"
            }
        }

        stage ('deb: build emacs') {
            when { expression { skip_build  == false } }
            steps {
                sh "docker build -f debian/Dockerfile --build-arg PREFIX=/emacs/target --build-arg VERSION=${version} --target builder -t benediktkr/emacs:builder-${version} ."
                sh "docker container create --name emacs_debian_builder benediktkr/emacs:builder-${version}"

                dir('dist/') {
                    sh "docker container cp emacs_debian_builder:/emacs/debian/ ."
                }
            }
        }
        stage('deb: container') {
            when { expression { skip_build == false } }
            steps {
                sh "docker build -f debian/Dockerfile -t benediktkr/emacs:${version} ."
            }
        }
    }

    post {
        success {
            archiveArtifacts(
                artifacts: 'dist/*/*.tar.gz,dist/debian/*.deb',
                fingerprint: true
            )
            sh "cp dist/*/*.tar.gz ${env.JENKINS_HOME}/artifacts"
            sh "cp dist/debian/*.deb ${env.JENKINS_HOME}/artifacts"

            script {
                if ( !skip_build ) {
                    sh "docker push benediktkr/emacs:${version}"
                }
            }
        }
        cleanup {
            script {
                if (! skip_build ) {
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
