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
    maven "mvn_3.6.3"
  }

  stages {

    stage('Cloning Git') {
      steps {
        git 'https://github.com/Some/Java/Project/URL'
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'mvn clean install -DskipTests'
      }
    }

    stage('Download WS Script') {
      steps {
                sh '''if ! [ -f ./wss-unified-agent.jar ] 
                then curl -fSL -R -JO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar 
                if [[ "$(curl -sL https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar.sha256)" != "$(sha256sum wss-unified-agent.jar)" ]] ;
                then echo "Integrity Check Failed" 
                fi 
                fi'''
             }
    }
                       
    stage('Run WS Script') {
      steps { 
        sh 'java -jar wss-unified-agent.jar'
      }
    }
  }
} 
