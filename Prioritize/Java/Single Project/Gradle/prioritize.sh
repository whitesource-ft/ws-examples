#!/bin/bash

#### Prerequisite commands & installs
# apt-get update
# apt-get install -y curl git openjdk-8-jdk nano

#### Clone your repo & run script
# git clone <your repository> && cd ./<your repository>
# chmod +x ./prioritize.sh
# ./prioritize.sh

#### Build application & check JAVA_HOME
echo  $JAVA_HOME
./gradlew build -x test

#### Run WS Prioritize
curl -LJO https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar
echo UA downloaded successfully
# replace .jar with .war or .ear if needed
export WARFILE=$(find ./ -type f -wholename "*./build/*.jar")
export WS_APIKEY=503ab5d74f03468abe4a757c9fcb6bcb4536d5e2e46246b5b9d95676f6692fc7
export WS_USERKEY=d2f4b03ff48740bc95ad7906b3a11610098a779020b84e67a5c0f1b85d164303
export WS_ENABLEIMPACTANALYSIS=true
export WS_REQUIREKNOWNSHA1=false
export WS_RESOLVEALLDEPENDENCIES=false
export GRADLE_RESOLVEDEPENDENCIES=true
export GRADLE_AGGREGATEMODULES=true
export WS_GRADLE_PREFERREDENVIRONMENT=wrapper
export WS_GRADLE_WRAPPERPATH=./gradlew
export WS_FILESYSTEMSCAN=false
export WS_PRODUCTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $4}')
export WS_PROJECTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $5}' | awk -F "." '{print $1}')-Prioritize
java -jar wss-unified-agent.jar -appPath $WARFILE -d ./
