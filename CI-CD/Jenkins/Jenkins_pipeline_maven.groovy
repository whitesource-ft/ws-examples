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
              script {
                    echo "Downloading WhiteSource Unified Agent and Checking Integrity"
                    sh 'curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar'
                    ua_jar_checksum=sh(returnStdout: true, script: "sha256sum 'wss-unified-agent.jar'")
                    ua_integrity_file=sh(returnStdout: true, script: "curl -sL https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar.sha256")
                    if ("${ua_integrity_file}" == "${ua_jar_checksum}") {
                        echo "Integrity Check Passed"
                    } else {
                        echo "Integrity Check Failed"
                        exit 1
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
