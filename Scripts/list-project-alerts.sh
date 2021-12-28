#!/bin/bash

# Description:
# This script uses WhiteSource's API to display (in the stdout) a list of
# vulnerabilities affecting the last scanned project(s).
# It is intended to be executed from the scan's working directory, either
# independently or following a Unified Agent scan.

# Prerequisites:
# apt install jq curl
# WS_GENERATEPROJECTDETAILSJSON: true
# WS_USERKEY (admin assignment is required)
# WS_WSS_URL

# Known Issues:
# The API response will be filtered by default based on the .cvss3_severity
# property. If a given vulnerability alert does not have a CVSS3 severity (i.e.
# the .vulnerability.cvss3_severity property is blank), that alert will not be
# included in the results. To use CVSS2 for filtering, change the jq condition
# below from `.vulnerability.cvss3_severity` to `.vulnerability.severity`.
# Note that when doing so, however, while the alert count will be accurate,
# some alerts might display a different severity than in the UI.

WS_API_URL="$(echo "${WS_WSS_URL/agent/'api/v1.3'}")"
PROJECT_DETAILS="./whitesource/scanProjectDetails.json"
showColors=true

if $showColors ; then
    RD="\e[1;31m"
    GN="\e[1;32m"
    YW="\e[1;33m"
    BL="\e[1;34m"
    NC="\e[0m"
fi

declare -a projects=( $(cat $PROJECT_DETAILS | jq -r '.projects[] | (.projectToken + "," + .projectName)') )

for project in "${projects[@]}"; do
    IFS=, read projectToken projectName <<< "$project"
    printf "\nAlerts for project: ${BL}%s${NC}\n" "$projectName"
    apiRes="$(curl -s -X POST -H "Content-Type: application/json" -d '{ "requestType": "getProjectAlertsByType", "alertType": "SECURITY_VULNERABILITY", "userKey": "'"$WS_USERKEY"'", "projectToken": '"$projectToken"' }' $WS_API_URL)"

    # High severity CVEs
    cveH="$(echo "$apiRes" | jq -r '.alerts[] | select(.vulnerability.cvss3_severity=="high") | ("[H] " + .vulnerability.name + " - " + .library.filename)')"
    cveCountH="$([ "${#cveH}" -gt 0 ] && echo "$cveH" | wc -l || echo 0)"

    # Medium severity CVEs
    cveM="$(echo "$apiRes" | jq -r '.alerts[] | select(.vulnerability.cvss3_severity=="medium") | ("[M] " + .vulnerability.name + " - " + .library.filename)')"
    cveCountM="$([ "${#cveM}" -gt 0 ] && echo "$cveM" | wc -l || echo 0)"

    # Low severity CVEs
    cveL="$(echo "$apiRes" | jq -r '.alerts[] | select(.vulnerability.cvss3_severity=="low") | ("[L] " + .vulnerability.name + " - " + .library.filename)')"
    cveCountL="$([ "${#cveL}" -gt 0 ] && echo "$cveL" | wc -l || echo 0)"

    printf "Alerts: ${RD}$cveCountH High${NC}, ${YW}$cveCountM Medium${NC}, ${GN}$cveCountL Low${NC}\n\n"
    printf "${RD}$cveH${NC}\n"
    printf "${YW}$cveM${NC}\n"
    printf "${GN}$cveL${NC}\n"
done
