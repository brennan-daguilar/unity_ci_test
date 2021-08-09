pipeline {
    agent {
        docker {
            image 'unityci/editor:2020.3.12f1-windows-mono-0.15'
            args '-u root --privileged'
        }
    }
    environment {
        UNITY_LICENSE_FILE = credentials('UNITY_LICENSE_FILE')
        UNITY_VERSION = '2020.3.12f1'
        IMAGE = 'unityci/editor'
        IMAGE_VERSION = '0.15'
        BUILD_TARGET = 'StandaloneWindows64'
    }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Configure Unity License') {
            steps {
                sh '''#!/bin/bash

                    set -e
                    set -x
                    mkdir -p /root/.cache/unity3d
                    mkdir -p /root/.local/share/unity3d/Unity/
                    set +x

                    UPPERCASE_BUILD_TARGET=${BUILD_TARGET^^};

                    if [ $UPPERCASE_BUILD_TARGET = "ANDROID" ]
                    then
                        if [ -n $ANDROID_KEYSTORE_BASE64 ]
                        then
                            echo '$ANDROID_KEYSTORE_BASE64 found, decoding content into keystore.keystore'
                            echo $ANDROID_KEYSTORE_BASE64 | base64 --decode > keystore.keystore
                        else
                            echo '$ANDROID_KEYSTORE_BASE64'" env var not found, building with Unity's default debug keystore"
                        fi
                    fi

                    LICENSE="UNITY_LICENSE_"$UPPERCASE_BUILD_TARGET

                    if [ -z "${!LICENSE}" ]
                    then
                        echo "$LICENSE env var not found, using default UNITY_LICENSE env var"
                        LICENSE=UNITY_LICENSE
                    else
                        echo "Using $LICENSE env var"
                    fi

                    echo "Writing $LICENSE to license file /root/.local/share/unity3d/Unity/Unity_lic.ulf"
                    echo "${!LICENSE}" | tr -d '\r' > /root/.local/share/unity3d/Unity/Unity_lic.ulf

                    set -x

                '''       
            }
        }
        stage('Build') {
            steps {
                
                sh '''#!/bin/bash

                    set -e
                    set -x

                    echo "Building for $BUILD_TARGET"

                    export BUILD_PATH=$UNITY_DIR/Builds/$BUILD_TARGET/
                    mkdir -p $BUILD_PATH

                    ${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' unity-editor} \
                    -projectPath $UNITY_DIR \
                    -quit \
                    -batchmode \
                    -nographics \
                    -buildTarget $BUILD_TARGET \
                    -customBuildTarget $BUILD_TARGET \
                    -customBuildName $BUILD_NAME \
                    -customBuildPath $BUILD_PATH \
                    -executeMethod BuildCommand.PerformBuild \
                    -logFile /dev/stdout

                    UNITY_EXIT_CODE=$?

                    if [ $UNITY_EXIT_CODE -eq 0 ]; then
                    echo "Run succeeded, no failures occurred";
                    elif [ $UNITY_EXIT_CODE -eq 2 ]; then
                    echo "Run succeeded, some tests failed";
                    elif [ $UNITY_EXIT_CODE -eq 3 ]; then
                    echo "Run failure (other failure)";
                    else
                    echo "Unexpected exit code $UNITY_EXIT_CODE";
                    fi

                    ls -la $BUILD_PATH
                    [ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
                '''
            }
        }
    }
}
