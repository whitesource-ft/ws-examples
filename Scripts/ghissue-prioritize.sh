#!/bin/bash
# Prerequisites:
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_PRODUCTNAME
# WS_PROJECTNAME
# WS_USERKEY
# WS_APIKEY
# WS_WSS_URL

# TODO - Add ERROR handling
# TODO - use libraryname + CVE instead of just CVE, ignores too many right now

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
WS_URL=$(echo $WS_WSS_URL | awk -F "/agent" '{print $1}')
echo "productName" $WS_PRODUCTNAME
echo "projectName" $WS_PROJECTNAME
echo "projectToken" $WS_PROJECTTOKEN
echo "wssUrl" $WS_URL


### getProjectAlertsbyType
curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectAlertsByType',   'userKey' : '$WS_USERKEY', 'alertType': 'SECURITY_VULNERABILITY',  'projectToken': '$WS_PROJECTTOKEN','format' : 'json'}' | jq '.alerts[]' >>alerts.json
echo "saving alerts.json"

### getProjectSecurityAlertsbyVulnerabilityReport - finds Red Shields
curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq -r '.alerts[] | select(.euaShield=="RED") | .vulnerabilityId' >> redshields.txt
echo 'saving redshields.txt'
cat redshields.txt && echo "cat of redshields"

redshieldlist=`cat redshields.txt`
### Get CVE by Red Shield
for REDSHIELDVULN in $redshieldlist
do
echo "REDSHIELDVULN:"$REDSHIELDVULN

## Get Github issue number by CVE
REDSHIELDGHISSUE=$(gh issue list -S "$REDSHIELDVULN in:title,body" --json number --jq '.[] | .number ')
echo "REDSHIELDGHISSUE:"$REDSHIELDGHISSUE

### Get keyUuid
KEYUUID=$(jq -r --arg REDSHIELDVULN $REDSHIELDVULN '. | select(.vulnerability.name==$REDSHIELDVULN) | .library.keyUuid' alerts.json)
echo "KEYUIID:" $KEYUUID

PROJECTID=$(jq -r --arg REDSHIELDVULN $REDSHIELDVULN '. | select(.vulnerability.name==$REDSHIELDVULN) | .projectId' alerts.json)
echo "PROJECTID:" $PROJECTID

### Construct Link
EUALINK="$WS_URL/Wss/WSS.html#!libraryVulnerabilities;uuid=$KEYUUID;project=$PROJECTID"
echo $EUALINK

gh issue comment $GHISSUE --body "Red Shield Alert - An effective vulnerability has been found in your open-source code demanding urgent remediation steps.  $EUALINK"

done

### getProjectSecurityAlertsbyVulnerabilityReport - finds Green Shields
curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProjectSecurityAlertsByVulnerabilityReport',   'userKey' : '$WS_USERKEY',   'projectToken': '$WS_PROJECTTOKEN', 'format' : 'json'}' | jq -r '.alerts[] | select(.euaShield=="GREEN") | .vulnerabilityId' >> greenshields.txt
echo 'saving greenshields.txt'

# Get productToken from WS_PRODUCTNAME
WS_PRODUCTTOKEN=$(curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getAllProducts',   'userKey' : '$WS_USERKEY',  'orgToken': '$WS_APIKEY'}' | jq -r --arg WS_PRODUCTNAME $WS_PRODUCTNAME '.products[] | select(.productName==$WS_PRODUCTNAME) | .productToken')
echo "getting productToken" $WS_PRODUCTTOKEN

### getProductAlertsbyType
curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'getProductAlertsByType',   'userKey' : '$WS_USERKEY', 'alertType': 'SECURITY_VULNERABILITY',  'productToken': '$WS_PRODUCTTOKEN','format' : 'json'}' >>productalerts.json
echo "saving productalerts.json"

greenshieldlist=`cat greenshields.txt`
### Get CVE by Red Shield
for GREENSHIELDVULN in $greenshieldlist
do
echo "GREENSHIELDVULN:"$GREENSHIELDVULN

## Get Github issue number by CVE
GREENSHIELDGHISSUE=$(gh issue list -S "$GREENSHIELDVULN in:title,body" --json number --jq '.[] | .number ')
echo "GREENSHIELDGHISSUE:"$GREENSHIELDGHISSUE

gh issue comment $GREENSHIELDGHISSUE --body "Green Shield Alert - This vulnerability is not effective and has been automatically ignored."

IGNORES=$(jq -r --arg GREENSHIELDVULN $GREENSHIELDVULN '[.alerts[] | select(.vulnerability.name==$GREENSHIELDVULN)|.alertUuid] |@csv '  productalerts.json)
echo "Ignoring the following alertUuids"$IGNORES

curl --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json' --header 'Accept-Charset: UTF-8'  --data-raw '{   'requestType' : 'ignoreAlerts',   'userKey' : '$WS_USERKEY', 'orgToken' : '$WS_APIKEY',  'alertUuids' : ['$IGNORES'], 'comments' : "green shield vulnerabilities are not reachable or exploitable"}'

done


