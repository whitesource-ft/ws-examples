#!/bin/bash
# Generic example for scanning for dependencies with the WhiteSource Unified Agent 

export WS_APIKEY=<your-api-key>
export WS_USERKEY=<your-user-key>
export WS_PRODUCTNAME=<your-product-name>
export WS_PROJECTNAME=<your-project-name>
export WS_WSS_URL=https://saas.whitesourcesoftware.com/agent
curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
echo Unified Agent downloaded successfully
java -jar wss-unified-agent.jar