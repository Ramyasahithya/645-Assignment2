pipeline {
    agent any
    environment {
        IMAGE_TAG = "${env.BUILD_ID}"  
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
                    withCredentials([file(credentialsId: 'kuberntes-id', variable: 'KUBECONFIG')]) {
                        // updating the image tag in deployment and apply the new deployment using rollout
                        sh """
                        kubectl set image deployment/surveyform-deployment form-container=ramya0602/form:${env.IMAGE_TAG} -n default --record
                        kubectl rollout status deployment/surveyform-deployment -n default
                        """
                        sh 'kubectl apply -f service.yaml'
                    }
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
