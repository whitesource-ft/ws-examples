#!/bin/bash
# Prerequisites 
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY

# Routing to the right WS instance
declare -a servers=("saas" "saas-eu" "app" "app-eu")

for i in "${servers[@]}"
do
    if [ $1 = $i ]; then
        WS_URL="https://$i.whitesourcesoftware.com"
    fi
done

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)

curl --output ./whitesource/riskreport.pdf --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectRiskReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/inventoryreport.xlsx --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProductInventoryReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/duediligencereport.pdf --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectDueDiligenceReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'