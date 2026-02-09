pipeline {
    agent any

    environment {
        PROJECT_NAME = "flask-todo-cicd"
        APP_SERVER_HOST = "172.31.35.180"
        APP_SERVER_USER = "ubuntu"
        APP_SERVER_DIR = "/home/ubuntu/Two-Tier_Flask-CI-CD"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Cloning repository on Jenkins server..."
                checkout scm
            }
        }

        stage('Sync Code to App Server') {
            steps {
                echo "Syncing code to app server via rsync..."
                sh '''
                rsync -avz --delete \
                  --exclude '.git' \
                  --exclude '.env' \
                  -e "ssh -o StrictHostKeyChecking=no" \
                  ./ ${APP_SERVER_USER}@${APP_SERVER_HOST}:${APP_SERVER_DIR}/
                '''
            }
        }

        stage('Pre-Deployment Check') {
            steps {
                echo "Verifying scripts on app server..."
                sh '''
                ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} "
                  cd ${APP_SERVER_DIR} && 
                  chmod +x scripts/*.sh && 
                  ls -l scripts
                "
                '''
            }
        }

        stage('Prepare Environment') {
            steps {
                echo "Preparing environment configuration on app server..."
                sh '''
                ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} "
                  cd ${APP_SERVER_DIR} && 
                  if [ ! -f .env ]; then
                    echo '[INFO] .env not found, creating from .env.example'
                    cp .env.example .env
                  else
                    echo '[INFO] .env already exists'
                  fi
                "
                '''
            }
        }

        stage('Shutdown Existing Application') {
            steps {
                echo "Stopping existing containers on app server..."
                sh '''
                ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} "
                  cd ${APP_SERVER_DIR} && 
                  ./scripts/stop.sh || true
                "
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                echo "Starting application on app server..."
                sh '''
                ssh -o StrictHostKeyChecking=no ${APP_SERVER_USER}@${APP_SERVER_HOST} "
                  cd ${APP_SERVER_DIR} && 
                  ./scripts/start.sh
                "
                '''
            }
        }

    }

    post {
        success {
            echo "Deployment completed successfully"
        }
        failure {
            echo "Deployment failed"
        }
    }
}