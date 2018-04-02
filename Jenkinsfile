pipeline {
  agent any
  environment {
    dockerhub_account="coul"
  }

  stages {
    stage('Build and Dockerize'){
      steps {
        sh "docker build -t ${dockerhub_account}/nginx-lua:1.0 ."
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
          sh "docker push ${dockerhub_account}/nginx-lua:1.0"
        }
      }
    }

    stage('Deploy'){
      steps {
      withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
          sh ''' docker-machine create --driver amazonec2 \
             --amazonec2-access-key ${AWS_ACCESS_KEY_ID} \
             --amazonec2-secret-key ${AWS_SECRET_ACCESS_KEY} \
             --amazonec2-region eu-west-2 \
             --amazonec2-ssh-user ubuntu \
             --amazonec2-instance-type "t2.micro" \
             --amazonec2-open-port 80 \
             test5

             docker run -d ${dockerhub_account}/nginx-lua:1.0
          '''
          }

      }


    }
  }
}
