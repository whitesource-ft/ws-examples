pipeline {
    
  agent any
  
  environment {
       WS_APIKEY = "${APIKEY}" //Taken from Jenkins Global Environment Variables 
       WS_WSS_URL = "${WSURL}" //Taken from Jenkins Global Environment Variables
       WS_USERKEY = "${USERKEY}" //Taken from Jenkins Global Environment Variables
       WS_PRODUCTNAME = "Jenkins_Pipeline"
       WS_PROJECTNAME = "${JOB_NAME}"
   }
  
  tools {
    nodejs "nodejs-17.3.1"
  }
  
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/Some/Java/Project/URL'
      }
    }
    
    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Download WS Script') {
      steps {
                script {
                    if (fileExists('./wss-unified-agent.jar')) {
                        echo "File already exists"
                    } else {
                            sh 'curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar'
                        }
                    }
             }
    }
    
    stage('Run WS Script') {
      steps {
        sh 'java -jar wss-unified-agent.jar'
      }
    }
  }
}
