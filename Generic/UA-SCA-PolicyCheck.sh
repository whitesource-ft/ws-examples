#!/bin/bash
# Generic example for scanning for dependencies and using WhiteSource's policy check as a gateway with the WhiteSource Unified Agent


# [GH] GITHUB_REF_NAME
# [AzDO] Build.SourceBranchName
# [Jenkins] GIT_BRANCH

export WS_APIKEY=<your-api-key>
export WS_USERKEY=<your-user-key>
export WS_PRODUCTNAME=<your-product-name>
export WS_PROJECTNAME=<your-project-name>
export WS_WSS_URL=https://saas.whitesourcesoftware.com/agent
export WS_CHECKPOLICIES=true
if [[ "$BRANCH_NAME" =~ ^feature[-_/](.*) ]] ; then
    export WS_FORCEUPDATE=false
    export WS_FORCEUPDATE_FAILBUILDONPOLICYVIOLATION=false
elif [[ "$BRANCH_NAME" =~ ^master|main$ ]] ; then
    export WS_FORCEUPDATE=true
    export WS_FORCEUPDATE_FAILBUILDONPOLICYVIOLATION=false
elif [[ "$BRANCH_NAME" =~ ^release[-_/](.*) ]] ; then
    export WS_FORCEUPDATE=true
    export WS_FORCEUPDATE_FAILBUILDONPOLICYVIOLATION=true
fi

curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
echo Unified Agent downloaded successfully
java -jar wss-unified-agent.jar
