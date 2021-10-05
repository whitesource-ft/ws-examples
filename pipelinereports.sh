#!/bin/bash
# Prerequisites 
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY

# Add the following after calling the unified agent in any pipeline file to save reports from the scanned project to the whitesource logs folder
# then use your pipeline publish feature to save the whitesource log folder as an artifact as shown in the README
#         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelinereports.sh
#         chmod +x ./pipelinereports.sh && ./pipelinereports.sh

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
APIURL=https://saas.whitesourcesoftware.com
curl --output ./whitesource/riskreport.pdf --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectRiskReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/inventoryreport.xlsx --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProductInventoryReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/duediligencereport.pdf --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectDueDiligenceReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'