pipeline {
  agent any

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
                    if (fileExists('./wss-unified-agent.jar')) {
                        echo "File already exists"
                    } else {
                            sh 'curl -LJO https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar'
                        }
                    }
             }
    }
                       
    stage('Run WS Script') {
      steps {
        # APIKEY and URL can taken from Jenkins Global Environment Variables  
        sh 'java -jar wss-unified-agent.jar -apiKey ${APIKEY} -wss.url ${URL} -product Jenkins_Pipeline -project ${JOB_NAME}'
      }
    }
  }
} 