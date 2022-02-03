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