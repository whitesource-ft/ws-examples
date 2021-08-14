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

### getProjectAlertsbyType
curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectAlertsByType',   'userKey' : '$WS_USERKEY', 'alertType': 'SECURITY_VULNERABILITY',  'projectToken': '$WS_PROJECTTOKEN','format' : 'json'}' | jq '.alerts[]' >>alerts.json
echo "saving alerts.json"

### getProjectSecurityAlertsbyVulnerabilityReport - finds Red Shields
curl --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq -r '.alerts[] | select(.euaShield=="RED") | .vulnerabilityId' >> redshields.txt
echo 'saving redshields.txt'

redshieldlist=`cat redshields.txt`
### Get CVE by Red Shield
for REDSHIELDVULN in $redshieldlist
do
echo "REDSHIELDVULN:"$REDSHIELDVULN

## Get Github issue number by CVE
GHISSUE=$(gh issue list -S $REDSHIELDVULN --json number --jq '.[] | .number ')
echo "GHISSUE:"$GHISSUE

### Get keyUuid
KEYUUID=$(jq -r --arg REDSHIELDVULN $REDSHIELDVULN '. | select(.vulnerability.name==$REDSHIELDVULN) | .library.keyUuid' alerts.json)
echo "KEYUIID:" $KEYUUID

PROJECTID=$(jq -r --arg REDSHIELDVULN $REDSHIELDVULN '. | select(.vulnerability.name==$REDSHIELDVULN) | .projectId' alerts.json)
echo "PROJECTID:" $PROJECTID

### Construct Link
EUALINK="$APIURL/Wss/WSS.html#!libraryVulnerabilities;uuid=$KEYUUID;project=$PROJECTID"
echo $EUALINK

gh issue comment $GHISSUE --body "Red Shield Alert - An effective vulnerability has been found in your open-source code demanding urgent remediation steps.  $EUALINK"

done