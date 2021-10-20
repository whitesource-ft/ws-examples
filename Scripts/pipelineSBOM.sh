#!/bin/bash
# Prerequisites 
# apt install jq curl python3 python3-pip
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY
# WS_APIKEY

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
#optionally use a tagged release instead of latest
# git checkout -b v0.2.4
pip3 install -r requirements.txt
cd ./sbom_report

python3 ./sbom_report.py -u $WS_USERKEY -k $WS_APIKEY -s $WS_PROJECTTOKEN -a $WS_URL -t tv rdf json -o ../../whitesource