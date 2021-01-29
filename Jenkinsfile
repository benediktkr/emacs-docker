pipeline {
    agent any
    options {
        timestamps()
        ansiColor("xterm")
        disableConcurrentBuilds()
    }
    stages {
        stage('amzn') {
            steps {
                sh './jenkins.sh amzn'
            }
        }

        stage('debian') {
            steps {
                sh './jenkins.sh debian'
            }
        }
    }
}
