pipeline {
    agent any

    environment {
        // Docker Hub credentials
        DOCKERHUB_CREDENTIALS = credentials('kprashant007-dockerhub')
        AWS_CREDENTIALS = credentials('awsJenkinsUser')
        AWS_REGION = 'ap-south-1'
        AWS_EC2_INSTANCE = 'ec2-user@13.234.202.47'
        IMAGE_NAME = 'hello-world-api'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/amrut90/dotnetproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub
                    withDockerRegistry([credentialsId: 'dockerhub-credentials', url: 'https://index.docker.io/v1/']) {
                        // Push the Docker image
                        sh 'docker push ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG}'
                    }
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    // Deploy to AWS EC2 instance
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i /path/to/your/private-key.pem ${AWS_EC2_INSTANCE} << EOF
                        docker pull ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker stop myapi || true
                        docker rm myapi || true
                        docker run -d --name myapi -p 80:80 ${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG}
                        EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Build and deployment completed successfully!"
        }
        failure {
            echo "There was an error in the build or deployment process."
        }
    }
}
