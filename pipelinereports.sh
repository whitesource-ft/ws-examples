#!/bin/bash
# Prerequisites 
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true

# Add the following after calling the unified agent in any pipeline file to save reports to the ./whitesource folder
# then use your pipeline publish feature to save the ./whitesource folder as an artifact
#         chmod +x ./pipelinereports.sh && ./pipelinereports.sh

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
APIURL=https://saas.whitesourcesoftware.com
curl --output ./whitesource/riskreport.pdf --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectRiskReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/inventoryreport.xlsx --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProductInventoryReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
curl --output ./whitesource/duediligencereport.pdf --request POST $APIURL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectDueDiligenceReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'