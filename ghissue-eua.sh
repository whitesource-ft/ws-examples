#!/bin/bash
# Add the following after calling the unified agent in a github-action.yml file from the WhiteSource Field Tookit
#         chmod +x ./ghissue-eua.sh
#          ./ghissue-eua.sh

APIURL=https://saas.whitesourcesoftware.com
WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)

### Get CVE by Red Shield
REDSHIELD=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq '.alerts | .[] | select(.euaShield=="RED") | .vulnerabilityId')
echo $REDSHIELD

## Get Github issue number by CVE
GHISSUE=$(gh issue list -S $REDSHIELD --json number --jq '.[] | .number ')
echo $GHISSUE

### Get keyUuid - requires productName and projectName
KEYUUID=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getOrganizationEffectiveUsageAnalysis',   'userKey' : '$WS_USERKEY',   'orgToken': '$WS_APIKEY','format' : 'json'}' | jq -r '.products | .[] | select(.productName=="$WS_PRODUCTNAME") | .projects | .[] | select(.projectName=="$WS_PROJECTNAME") | .libraries | .[] | select(.resultingShield=="RED") | .keyUuid')
echo $KEYUUID

### Get ProjectID
PROJECTID=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getOrganizationEffectiveUsageAnalysis',   'userKey' : '$WS_USERKEY',   'orgToken': '$WS_APIKEY','format' : 'json'}' | jq '.products | .[] | select(.productName=="$WS_PRODUCTNAME") | .projects | .[] | select(.projectName=="$WS_PROJECTNAME") | .projectId ')
echo $PROJECTID

### Construct Link
EUALINK="$APIURL/Wss/WSS.html#!libraryVulnerabilities;uuid=$KEYUUID;project=$PROJECTID"
echo $EUALINK

gh issue comment $GHISSUE --body "$EUALINK"
