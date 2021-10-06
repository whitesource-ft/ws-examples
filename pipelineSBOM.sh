#!/bin/bash
# Prerequisites 
# apt install jq curl python3 python3-pip
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY
# WS_APIKEY

# Add the following after calling the unified agent in any pipeline file to create an SPDX output from the scanned project to the whitesource logs folder
# then use your pipeline publish feature to save the whitesource log folder as an artifact as shown in the README
#         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelineSBOM.sh
#         chmod +x ./pipelineSBOM.sh && ./pipelineSBOM.sh WS_URL
#         URL options: saas, saas-eu, app, app-eu

# More information & usage regarding WS SBOM generator can be found at https://github.com/whitesource-ps/ws-sbom-spdx-report

# Routing to the right WS instance
declare -a servers=("saas" "saas-eu" "app" "app-eu")

for i in "${servers[@]}"
do
    if [ $1 = $i ]; then
        WS_URL="https://$i.whitesourcesoftware.com"
    fi
done

if [ -z $WS_URL ]; then
    echo "No valid WhiteSource server URL provided"
    exit 1
fi

WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)

git clone https://github.com/whitesource-ps/ws-sbom-report.git && cd ./ws-sbom-report
pip3 install -r requirements.txt
cd ./sbom_report

python3 ./sbom_report.py -u $WS_USERKEY -k $WS_APIKEY -s $WS_PROJECTTOKEN -a $WS_URL -t tv -o ../../whitesource