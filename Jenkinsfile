// Ramyasahithya Magani - G01425752
// Arsitha Sathu - G01445215
// Athiksha Venkannagari - G01461169
// Sreshta Kosaraju - G01460468

// Jenkinsfile defines Jenkins pipeline automatomation process of building and deploying a Docker image for a Kubernetes application.
// It clones the repository, builds and pushes the Docker image to Docker Hub, and updates the Kubernetes deployment to use the new image. 
// Finally, it provides success or failure notifications based on the pipeline's execution results.


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
                        echo "Updating the docker image: ramya0602/form:${env.IMAGE_TAG}"

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
