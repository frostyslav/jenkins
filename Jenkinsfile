pipeline {
  environment {
     LUAJIT_VER = "2.0.5"
  }
  agent any

  stages {
    stage('Build'){
      steps {
        sh '''
        echo $LUAJIT_VER
        '''
      }
    }

  }
}
