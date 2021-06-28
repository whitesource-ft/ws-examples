#!/bin/bash
# Prerequisites:
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true

# Add the following after calling the unified agent in a github-action.yml file from the WhiteSource Field Tookit
#         chmod +x ./ghissue-eua.sh && ./ghissue-eua.sh
# Known issue - this script will not work on the first scan as EUA needs to process on the backend before results are available.
# TODO - Add ERROR handling
APIURL=https://saas.whitesourcesoftware.com
WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
echo "productName" $WS_PRODUCTNAME
echo "projectName" $WS_PROJECTNAME
echo "projectToken" $WS_PROJECTTOKEN

### Get ProjectID
PROJECTID=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getOrganizationEffectiveUsageAnalysis',   'userKey' : '$WS_USERKEY',   'orgToken': '$WS_APIKEY','format' : 'json'}' | jq --arg WS_PRODUCTNAME $WS_PRODUCTNAME --arg WS_PROJECTNAME $WS_PROJECTNAME  '.products[] | select(.productName==$WS_PRODUCTNAME) | .projects[] | select(.projectName==$WS_PROJECTNAME) | .projectId ')
echo "PROJECTID:"$PROJECTID

### Get CVE by Red Shield
for REDSHIELDVULN in $(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq -r '.alerts[] | select(.euaShield=="RED") | .vulnerabilityId')
do
echo "REDSHIELDVULN:"$REDSHIELDVULN

## Get Github issue number by CVE
GHISSUE=$(gh issue list -S $REDSHIELDVULN --json number --jq '.[] | .number ')
echo "GHISSUE:"$GHISSUE

### Get LibraryName
LIBNAME=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq -r --arg REDSHIELDVULN $REDSHIELDVULN '.alerts[] | select(.vulnerabilityId==$REDSHIELDVULN) | .libraryName')
echo "LIBNAME:"$LIBNAME

### Get keyUuid
KEYUUID=$(curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getOrganizationEffectiveUsageAnalysis',   'userKey' : '$WS_USERKEY',   'orgToken': '$WS_APIKEY','format' : 'json'}' | jq -r --arg WS_PRODUCTNAME $WS_PRODUCTNAME --arg WS_PROJECTNAME $WS_PROJECTNAME --arg LIBNAME $LIBNAME '.products[] | select(.productName==$WS_PRODUCTNAME) | .projects[] | select(.projectName==$WS_PROJECTNAME) | .libraries[] | select(.name==$LIBNAME) | .keyUuid')
echo "KEYUIID:" $KEYUUID

### Construct Link
EUALINK="$APIURL/Wss/WSS.html#!libraryVulnerabilities;uuid=$KEYUUID;project=$PROJECTID"
echo $EUALINK

gh issue comment $GHISSUE --body "Red Shield Alert - An effective vulnerability has been found in your open-source code demanding urgent remediation steps.  $EUALINK"

done
