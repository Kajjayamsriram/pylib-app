pipeline {
    agent {
        label 'smanager'
    }
    stages {
        stage('code') {
            steps {
                git branch: 'main', url: 'https://github.com/Kajjayamsriram/pylib-app.git'
            }
        }
        stage('CQA') {
            steps {
                script{
                    def scanHome = tool 'sonar';
                    withSonarQubeEnv('sonar-server') {
                      sh """
                      ${scanHome}/bin/sonar-scanner \
                      -Dsonar.projectKey=pyapp \
                      -Dsonar.qualitygate.wait=false
                      """
                    }
                }
            }
        }
        stage('Build'){
            steps{
                sh '''
                docker build -t sriramk16/pyapp:front .
                docker build -t sriramk16/pyapp:auth auth
                docker build -t sriramk16/pyapp:book book
                docker build -t sriramk16/pyapp:borrow borrow
                docker build -t sriramk16/pyapp:db database
                '''
            }
        }
        stage('ImageScan'){
            steps{
                sh '''
                trivy image sriramk16/pyapp:db
                trivy image sriramk16/pyapp:front
                trivy image sriramk16/pyapp:auth
                trivy image sriramk16/pyapp:book
                trivy image sriramk16/pyapp:borrow
                '''
            }
        }
        stage('Push') {
            steps{
                withDockerRegistry(credentialsId: 'docker-login', url: 'https://index.docker.io/v1/') {
                  sh '''
                  docker push sriramk16/pyapp:db
                  docker push sriramk16/pyapp:front
                  docker push sriramk16/pyapp:auth
                  docker push sriramk16/pyapp:book
                  docker push sriramk16/pyapp:borrow
                  '''
                }
            }
        }
        stage('Deploy'){
            steps{
                sh "docker stack deploy -c compose.yml pyapp"
            }
        }
    }
    post {
        success {
            echo "🚀 DEPLOYMENT SUCCESSFUL!"
        }
        failure{
            echo "🚀 DEPLOYMENT FAILED!"
        }
    }
}
