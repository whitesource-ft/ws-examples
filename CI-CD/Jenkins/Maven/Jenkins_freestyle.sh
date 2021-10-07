echo "Downloading WS"
if ! [ -f ./wss-unified-agent.jar ]; then
  curl -fSL -R -JO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
fi
echo "Exceute WS"
export WS_APIKEY=${APIKEY} #Taken from Jenkins Global Environment Variables
export WS_USERKEY=${USERKEY} #Taken from Jenkins Global Environment Variables
export WS_WSS_URL="https://saas.whitesourcesoftware.com/agent"
export WS_PRODUCTNAME=Jenkins
export WS_PROJECTNAME=${JOB_NAME}
java -jar wss-unified-agent.jar