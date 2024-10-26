pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('docker-pass') // Reading Docker credentials from Jenkins
        KUBECONFIG_CREDENTIALS = credentials('kubernetes-id')  // Reading k8s credentials from Jenkins
        IMAGE_TAG = "${env.BUILD_ID}"  // Set IMAGE_TAG to the Jenkins build ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/Ramyasahithya/645-Assignment2'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-pass', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PSW')]) {
                        sh 'echo $DOCKER_PSW | docker login -u $DOCKER_USER --password-stdin'
                    }
                    image = docker.build("ramya0602/form:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-pass') {
                        image.push()
                    }
                }
            }
        }

        stage('Update Deployment YAML and Deploy') {
            steps {
                script {
                    // Set image in deployment
                    sh "kubectl set image deployment/surveyform-deployment form-container=ramya0602/form:${env.IMAGE_TAG} -n default"

                    // Uncomment if using `envsubst` to update the YAML file dynamically
                    // sh 'envsubst < deployment.yaml > deployment-updated.yaml'

                    // Verify the updated deployment YAML file
                    sh 'cat deployment-updated.yaml'

                    // Apply the updated deployment.yaml to Kubernetes
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f deployment-updated.yaml
                    '''

                    // Uncomment to apply the service YAML as well
                    // sh 'kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f service.yaml'
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
