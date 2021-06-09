#!/bin/bash

export WS_APIKEY=<your-api-key>
export WS_USERKEY=<your-user-key>
export WS_PRODUCTNAME=<your-product-name>
export WS_PROJECTNAME=<your-project-name>
curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
echo Unified Agent downloaded successfully
java -jar wss-unified-agent.jar -d ./