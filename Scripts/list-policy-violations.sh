#!/bin/bash

# Description:
# This script parses the policyRejectionSummary.json file, following a 
# WhiteSource Unified Agent scan, and prints to the stdout the policies
# that where violated, as well as the libraries that violated them.

# The policyRejectionSummary.json file is created automatically under
# the agent log directory (./whitesource) during a scan that's configured
# to check policies.
# Every policy check overwrites this file, so this list is always specific
# to the last scan (that had policy check enabled).

# Prerequisites:
# apt install jq
# WS_CHECKPOLICIES: true

jsonFile="./whitesource/policyRejectionSummary.json"
libCount="$(cat $jsonFile | jq -r '.summary.totalRejectedLibraries')"

ShowLibSystemPath=true

echo ""
echo "WhiteSource Policy Violations"
echo "============================="
if [[ -v WS_PRODUCTNAME ]]; then echo "Product: $WS_PRODUCTNAME" ; fi
if [[ -v WS_PROJECTNAME ]]; then echo "Product: $WS_PROJECTNAME" ; fi
echo "Total Rejected Libraries: $libCount"
echo ""

cat $jsonFile | jq -c '.rejectingPolicies[]' | while read oPolicy; do
    for policy in "${oPolicy[@]}" ; do
        echo "Policy Name: $(echo "${policy//\\/\\\\}" | jq -r '(.policyName)')"
        echo "Policy Type: $(echo "${policy//\\/\\\\}" | jq -r '(.filterType)')"
        echo "Rejected Libraries:"
        if $ShowLibSystemPath ; then
            echo "$(echo "${policy//\\/\\\\}" | jq -r '.rejectedLibraries[] | ("  " + .name + "  (" + .systemPath + ")")')"
        else
            echo "$(echo "${policy//\\/\\\\}" | jq -r '.rejectedLibraries[] | ("  " + .name)')"
        fi
        echo ""
    done
done










declare -a policyRejectionSummary=( $(cat $jsonFile | jq -r '.rejectingPolicies[] | (.policyName + "," + .filterType + "," + .rejectedLibraries)') )

for project in "${projects[@]}"; do
    IFS=, read projectToken projectName <<< "$project"
    printf "\nWhiteSource Vulnerability Alerts for project: ${BL}%s${NC}\n" "$projectName"
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
    printf "\n"
done
