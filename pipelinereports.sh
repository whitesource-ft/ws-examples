#!/bin/bash
# Prerequisites 
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY

# Add the following after calling the unified agent in any pipeline file to save reports from the scanned project to the whitesource logs folder
# then use your pipeline publish feature to save the whitesource log folder as an artifact as shown in the README
#         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelinereports.sh
#         chmod +x ./pipelinereports.sh && ./pipelinereports.sh WS_URL
#         WS_URL options: saas, saas-eu, app, app-eu


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