pipeline {
  agent any

  stages {
    stage('Build and Dockerize'){
      steps {
        sh "docker build -t coul/nginx-lua:1.0 ."
      }
    }



    stage('Push image to dockerhub'){
      steps {
        /* Workaround to address issue with credentials stored in Jenkins not
        * being passed correctly to the docker registry
        * - ref https://issues.jenkins-ci.org/browse/JENKINS-38018 */
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-credentials',
        usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
          sh 'docker login -u $USERNAME -p $PASSWORD https://index.docker.io/v1/'}

        withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://registry.hub.docker.com']) {
          sh "docker push coul/nginx-lua:1.0"
        }
      }
    }

  }
}
