pipeline {
    agent any
    environment {
        REPO_NAME = 'amrut90/dotnetproject'
        DOCKER_IMAGE = "${REPO_NAME}:${BUILD_ID}"
        AWS_EC2_HOST = 'ec2-user@3.111.219.92'
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the GitHub repository
                git branch: 'main', url: 'https://github.com/amrut90/dotnetproject.git'
            }
        }
        stage('Build .NET Core API') {
            steps {
                // Build the application
                sh 'dotnet build'
            }
        }
        stage('Dockerize Application') {
            steps {
                // Build Docker image
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }
        stage('Push Docker Image') {
            steps {
                // Login to Docker Hub and push image
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to AWS EC2') {
            steps {
                sshagent(['aws-ec2-ssh']) {
                    // Pull and run the Docker image on EC2
                    sh """
                    ssh -o StrictHostKeyChecking=no ${AWS_EC2_HOST} 'docker pull ${DOCKER_IMAGE} && docker stop netcore-api || true && docker rm netcore-api || true && docker run -d -p 5000:80 --name netcore-api ${DOCKER_IMAGE}'
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
