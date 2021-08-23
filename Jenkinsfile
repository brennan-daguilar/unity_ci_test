pipeline {
    agent any
    environment {
        UNITY_LICENSE_FILE = credentials('UnityLicenseFile.ulf')
        UNITY_VERSION = '2020.3.12f1'
        IMAGE = 'unityci/editor'
        IMAGE_VERSION = '0.15'
        BUILD_NAME = "Testy"
    }
    stages {
        stage('Android') {
            agent {
                label 'unity-android'
            }
            environment {
                UNITY_LICENSE_FILE = credentials('UnityLicenseFile.ulf')
                UNITY_VERSION = '2020.3.12f1'
                IMAGE = 'unityci/editor'
                IMAGE_VERSION = '0.15'
                BUILD_NAME = "Testy"
                BUILD_TARGET = 'Android'
            }
            stages {
                stage('Configure Unity License') {
                    steps {
                        sh('./ci/before_script.sh')  
                    }
                }
                stage('Build') {
                    steps {
                        sh('./ci/build.sh')
                    }
                }       
            }         
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'Builds/**', followSymlinks: false
            }
        }
    }
}
