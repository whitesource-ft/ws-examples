# Variables are taken from the job Variables List
# For Example:
# WS_PRODUCTNAME = ${bamboo.planKey}
# WS_PROJECTNAME = ${bamboo.buildPlanName}
# WS_WSS_URL = https://saas.whitesourcesoftware.com/agent
# WS_APIKEY = {MASKED_APIKEY}
# WS_USERKEY = {MASKED_USERKEY}

# Download Unified Agent
curl -LJO https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar

# Scan with Unified Agent
java -jar wss-unified-agent.jar 