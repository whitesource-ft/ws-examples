#!/bin/bash
# Prerequisites 
# apt install jq curl python3
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY
# WS_APIKEY

# Add the following after calling the unified agent in any pipeline file to create an SPDX output from the scanned project to the whitesource logs folder
# then use your pipeline publish feature to save the whitesource log folder as an artifact as shown in the README
#         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelineSBOM.sh
#         chmod +x ./pipelineSBOM.sh && ./pipelineSBOM.sh

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
APIURL=https://saas.whitesourcesoftware.com

git clone https://github.com/whitesource-ps/ws-sbom-report.git && cd ./ws-sbom-report
pip3 install -r requirements.txt
cd ./sbom_report

python3 ./sbom_report.py -u $WS_USERKEY -k $WS_APIKEY -s $WS_PROJECTTOKEN -t tv -o ../../whitesource