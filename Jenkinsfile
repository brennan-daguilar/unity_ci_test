pipeline {
    agent {
        docker { image 'unityci/editor:2020.3.12f1-base-0.15' }
    }

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Configure Unity License') {
            sh '''
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
}
