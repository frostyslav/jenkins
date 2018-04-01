pipeline {
  agent any

  stages {
    stage('Build and Dockerize'){
      steps {
        sh "docker build -t nginx-lua:1.0 ."
      }
    }

    stage('Push image to dockerhub'){
      steps {
        withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://registry.hub.docker.com']) {
          sh "docker tag nginx-lua:1.0 coul/nginx-lua:1.0 && docker push coul/nginx-lua:1.0" 
        }
      }
    }

  }
}
