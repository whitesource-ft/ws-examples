#!/bin/bash
# Generic example for scanning docker images with the WhiteSource Unified Agent from Amazon Elastic Container Registry
# Glob patterns used scans & pulls all images with repositoryName containing "ubuntu"
# docker.pull.tags can be used instead of docker.pull.images - the default pulls all tags with associated images
# See docker.includes & docker.excludes sections for more detail - https://whitesource.atlassian.net/wiki/spaces/WD/pages/1544880156/Unified+Agent+Configuration+Parameters#Docker-Images

# Ensure the aws cli is configured with the correct login information - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
# aws configure

# Ensure docker is has a user and is logged in to AWS - # https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html
# aws ecr get-login-password --region <region> | docker login -u AWS -p <password> <aws_account_id>.dkr.ecr.<region>.amazonaws.com


# default images pulled is 10 - uncomment and change below value for more
# export WS_DOCKER_PULL_MAXIMAGES=10 

# docker pull commands are not run with sudo by default - uncomment below if sudo is needed
#export WS_DOCKER_LOGIN_SUDO=true

IMAGES=.*ubuntu.*
export WS_APIKEY=<your-api-key>
export WS_USERKEY=<your-user-key>
export WS_PRODUCTNAME=<your-product-name>
export WS_PROJECTNAME=doesnotmatter
export WS_DOCKER_AWS_ENABLE=true
export WS_DOCKER_PULL_ENABLE=true
export WS_DOCKER_PULL_IMAGES=$IMAGES
export WS_DOCKER_AWS_REGISTRYID=<your-aws-account-id>
export WS_DOCKER_INCLUDES=$IMAGES
export WS_DOCKER_SCANIMAGES=true
export WS_DOCKER_LAYERS=true
export WS_DOCKER_PROJECTNAMEFORMAT=repositoryNameAndTag
export WS_FILESYSTEMSCAN=false
curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
echo Unified Agent downloaded successfully
java -jar wss-unified-agent.jar 