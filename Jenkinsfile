pipeline {
  agent none

  stages {
    stage('Build'){
      steps {
        sh "docker build -t pzab/nginx-lua:1.0 ."
      }
    }

  }
}
