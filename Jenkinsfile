pipeline {
  agent none

  stages {
    stage('Build'){
      def image = docker.build('pzab/nginx-lua:1.0', '.')
    }

  }
}
