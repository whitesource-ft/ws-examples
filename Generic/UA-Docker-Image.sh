#!/bin/bash
# Generic example for scanning docker images with the WhiteSource Unified Agent
# Glob patterns used scan all pulled images with repository or tag containing "ubuntu"
# Scans only the pulled immage "maven:3.8-openjdk-8"
# See docker.includes & docker.excludes sections section for more detail - https://whitesource.atlassian.net/wiki/spaces/WD/pages/1544880156/Unified+Agent+Configuration+Parameters#Docker-Images

docker pull ubuntu:latest 
docker pull maven:3.8-openjdk-8

export WS_APIKEY=<your-api-key>
export WS_USERKEY=<your-user-key>
export WS_PRODUCTNAME=<your-product-name>
export WS_PROJECTNAME=doesnotmatter
export WS_DOCKER_INCLUDES=".*ubuntu.* maven:3.8-openjdk-8"
export WS_DOCKER_SCANIMAGES=true
export WS_DOCKER_LAYERS=true
export WS_DOCKER_PROJECTNAMEFORMAT=repositoryNameAndTag
export WS_FILESYSTEMSCAN=false
curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
echo Unified Agent downloaded successfully
java -jar wss-unified-agent.jar 