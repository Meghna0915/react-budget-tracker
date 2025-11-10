pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        IMAGE_NAME = "palmeghna/react-budget-tracker"
        TERRAFORM_DIR = "./terraform"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Meghna0915/react-budget-tracker.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push("latest")
                    }
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"]) {
                        sh """
                        terraform init
                        terraform apply -auto-approve -var 'docker_image=${IMAGE_NAME}:latest' -var 'key_name=your-key-pair-name'
                        """
                    }
                }
            }
        }

        stage('Output Server Info') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform output'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure and deployment successful!'
        }
        failure {
            echo '❌ Something went wrong during CI/CD pipeline.'
        }
    }
}