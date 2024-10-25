pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('Docker-id') // reading docker credentials from jenkins
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id')  // reading k8s credentials from jenkins
        IMAGE_TAG = "${env.BUILD_ID}"  // Set IMAGE_TAG to the Jenkins build ID
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Docker-id', passwordVariable: 'DOCKER_PSW', usernameVariable: 'DOCKER_USR')]) {
                        sh 'echo $DOCKER_PSW | docker login -u $DOCKER_USR --password-stdin'
                    }

                    image = docker.build("ramya0602/form:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'Docker-id') {
                        image.push()
                    }
                }
            }
        }

        stage('Update Deployment YAML and Deploy') {
            steps {
                script {
                    sh 'envsubst < deployment.yaml > deployment-updated.yaml'

                    // cat command to check if the deployment-updated.yaml is updated with the latest version of image
                    sh 'cat deployment-updated.yaml'

                    // Apply the updated deployment.yaml to Kubernetes (Rancher)
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f deployment-updated.yaml
                    '''

                    // applying the service.yaml
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f service.yaml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
