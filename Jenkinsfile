pipeline {
  agent any
  options { disableConcurrentBuilds() }
  environment {
    TARGET = "${env.BRANCH_NAME == 'master' ? 'prod' : 'dev'}"
  }
  stages {
    stage('Build image') {
      when { anyOf { branch 'dev'; branch 'master' } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh 'bash ./build.sh $TARGET $BUILD_NUMBER'
        }
      }
    }
    stage('Push image') {
      when { anyOf { branch 'dev'; branch 'master' } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh '''
            echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push $DOCKERHUB_USER/$TARGET:$BUILD_NUMBER
            docker push $DOCKERHUB_USER/$TARGET:latest
          '''
        }
      }
    }
    stage('Deploy') {
      when { branch 'master' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh 'bash ./deploy.sh prod $BUILD_NUMBER'
        }
      }
    }
  }
  post {
    always { sh 'docker logout || true' }
  }
}