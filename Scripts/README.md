# Scripts
This repository contains scripts for use with WhiteSource Unified agent scanning within a CI/CD pipeline.

- [Adding Red Shield Comment Links to GitHub Issues](#adding-red-shield-comment-links-to-github-issues)
- [Adding Red Shield Comments Links to GitHub Issues and Closing Green Shield Issues](#adding-red-shield-comments-links-to-github-issues-and-closing-green-shield-issues)
- [Reports Within a Pipeline](#reports-within-a-pipeline)
- [Pipeline SBOM Generation](#pipeline-sbom-generation)
- [Display Vulnerabilities Affecting a Project](#display-vulnerabilities-affecting-a-project)

<br>
<hr>

## Adding Red Shield Comment Links to GitHub Issues

[ghissue-eua.sh](ghissue-eua.sh)  

Add the following lines after the Unified Agent command in a GitHub action to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.

<br>
The following prequisites need to be met for the script to work
<br>

* `jq awk` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_PRODUCTNAME
  * WS_PROJECTNAME
  * WS_WSS_URL

```
curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/Scripts/ghissue-eua.sh 
chmod +x ./ghissue-eua.sh && ./ghissue-eua.sh
```

<br>
<hr>

## Adding Red Shield Comments Links to GitHub Issues and Closing Green Shield Issues

[ghissue-prioritize.sh](ghissue-prioritize.sh)  

Add the following lines after the Unified Agent command in a GitHub action to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.  If a the vulnerability has a green shield a comment will be made, the issue will be closed, and the vulnerability will be ignored in WhiteSource.

<br>
The following prequisites need to be met for the script to work
<br>

* `jq awk` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_PRODUCTNAME
  * WS_PROJECTNAME
  * WS_APIKEY
  * WS_WSS_URL

```
curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/Scripts/ghissue-prioritize.sh 
chmod +x ./ghissue-prioritize.sh && ./ghissue-prioritize.sh
```

<br>
<hr>

## Reports Within a Pipeline

Any WhiteSource report can also be published as a part of the pipeline.
Add the following after calling the unified agent in any pipeline file to save reports from the scanned project to the whitesource logs folder then use your [pipeline publish](../CI-CD#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact

<br>
The following prequisites need to be met for the script to work
<br>

* `jq awk` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_WSS_URL

```
        export WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
        export WS_URL=$(echo $WS_WSS_URL | awk -F "agent" '{print $1}')
         #RiskReport-Example
        curl --output ./whitesource/riskreport.pdf --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectRiskReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
         #InventoryReport-Example
        curl --output ./whitesource/inventoryreport.xlsx --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProductInventoryReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
         #DueDiligenceReport-Example
        curl --output ./whitesource/duediligencereport.pdf --request POST $WS_URL'/api/v1.3' --header 'Content-Type: application/json'  --data-raw '{"requestType":"getProjectDueDiligenceReport","userKey":"$WS_USERKEY","projectToken":"$WS_PROJECTTOKEN"}'
```

<br>
<hr>

## Pipeline SBOM Generation

Add the following after calling the unified agent in any pipeline to create an SPDX tag value output from the scanned project to the whitesource logs folder then use your [pipeline publish](../CI-CD#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact

<br>
The following prequisites need to be met for the below example to work
<br>

* `jq awk python3 python3-pip` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_APIKEY
  * WS_WSS_URL


```
        export WS_PROJECTTOKEN=$(jq -r '.projects | .[] | .projectToken' ./whitesource/scanProjectDetails.json)
        export WS_URL=$(echo $WS_WSS_URL | awk -F "agent" '{print $1}')
        pip install ws-sbom-generator
        ws_sbom_generator -u $WS_USERKEY -k $WS_APIKEY -s $WS_PROJECTTOKEN -a $WS_URL -t tv -o ./whitesource
```

More information & usage regarding the [WS SBOM generator](https://github.com/whitesource-ps/ws-sbom-spdx-report)


<br>
<hr>

## Display Vulnerabilities Affecting a Project

[list-project-alerts.sh](list-project-alerts.sh)  

This script can be added to the CI/CD pipeline (or executed independently) following the WhiteSource Unified Agent scan, to list vulnerabilities affecting the last scanned project(s).  

This script parses the `scanProjectDetails.json` file to get the `name` and `projectToken` of the project(s) created/updated during the last scan, and then uses WhiteSource's [getProjectAlertsByType](https://whitesource.atlassian.net/wiki/spaces/WD/pages/1651769359/Alerts+API#Project.2) API request to retrieve all the vulnerability alerts associated with that project. It then prints them to the standard output (`stdout`), sorted by severity and optionally color-coded.

<br>
The following prequisites need to be met for the script to work
<br>

* `jq curl` must be installed
* ENV variables must be set
  * `WS_GENERATEPROJECTDETAILSJSON: true`
  * `WS_USERKEY` (admin assignment is required)
  * `WS_WSS_URL`
  
```
./list-project-alerts.sh

Alerts for project: vulnerable-node
Alerts: 10 High, 4 Medium, 2 Low

[H] CVE-2017-16138 - mime-1.3.4.tgz
[H] CVE-2015-8858 - uglify-js-2.3.0.tgz
[H] CVE-2017-1000228 - ejs-0.8.8.tgz
[H] CVE-2017-1000048 - qs-4.0.0.tgz
[H] CVE-2020-8203 - lodash-4.17.11.tgz
[H] CVE-2021-23337 - lodash-4.17.11.tgz
[H] CVE-2019-5413 - morgan-1.6.1.tgz
[H] CVE-2019-10744 - lodash-4.17.11.tgz
[H] CVE-2017-16119 - fresh-0.3.0.tgz
[H] CVE-2015-8857 - uglify-js-2.3.0.tgz
[M] CVE-2020-28500 - lodash-4.17.11.tgz
[M] CVE-2017-16137 - debug-2.2.0.tgz
[M] CVE-2019-14939 - mysql-2.12.0.tgz
[M] WS-2018-0080 - mysql-2.12.0.tgz
[L] WS-2018-0589 - nwmatcher-1.3.9.tgz
[L] WS-2017-0280 - mysql-2.12.0.tgz
```

See known limitations [here](list-project-alerts.sh).

<br>
<hr>

