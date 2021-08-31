pipeline {
    agent {
        label 'unity-agent-wip'
    }
    stages {

        stage('Activate Unity License') {
            environment {
                UNITY_CREDENTIALS = credentials('UNITY_CREDENTIALS')
                UNITY_SERIAL = credentials('unity-pro-serial')
            }
            steps {
                sh('./ci/activate.sh')  
            }
        }

        stage('Build Android') {
            environment {
                UNITY_LICENSE_FILE = credentials('UnityLicenseFile.ulf')
                UNITY_VERSION = '2020.3.12f1'
                IMAGE = 'unityci/editor'
                IMAGE_VERSION = '0.15'
                BUILD_NAME = "Testy"
                BUILD_TARGET = 'Android'
            }

            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh('./ci/build.sh')
                }
            }
   
        }

        stage('Return Unity License') {
            steps {
                sh('./ci/return_license.sh')  
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'Builds/**', followSymlinks: false
            }
        }
    }
}
