pipeline {
    agent {
        kubernetes(
            k8sAgent(idleMinutes: 0, name: 'ruby', rubyRuntime: '2.7', defaultContainer: 'ruby')
        )
    }

    stages {
        stage('Setup job') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-app-key', usernameVariable: 'GH_APP', passwordVariable: 'GH_TOKEN')]) {
                    echo 'setup Git Config'
                    setGitConfig()
                }

                echo 'Install additional dependencies'
                sh 'gem install rake'
            }
        }

        stage('test') {
            when { expression { runTests } }

            steps {
                sh 'rake tests'
            }
        }

        stage('Check submodules?') {
            steps {
                script {
                    recogContentClosestTag = sh(script: 'git describe --abbrev=0', returnStdout: true).trim()
                    echo "${recogContentClosestTag}"
                }
            }
        }

        stage ('build?') {
            steps {
                // Looks to use rake build with some parameters...
                echo 'build'
            }
        }

        stage('Release?') {
            steps {
                echo 'release'
            }
        }
    }
}