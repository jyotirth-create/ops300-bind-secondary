
pipeline {
    agent { label 'podman' }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        REGISTRY = 'registry.assign.joza2.300.ops:5000'
        IMAGE_NAME = 'bind-secondary'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    podman build -t "$REGISTRY/$IMAGE_NAME:$BUILD_NUMBER" .
                '''
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'registry-auth',
                        usernameVariable: 'REG_USER',
                        passwordVariable: 'REG_PASS'
                    )
                ]) {
                    sh '''
                        printf '%s' "$REG_PASS" | podman login "$REGISTRY" \
                            --username "$REG_USER" --password-stdin

                        podman push "$REGISTRY/$IMAGE_NAME:$BUILD_NUMBER"

                        podman logout "$REGISTRY"
                    '''
                }
            }
        }
    }
}
