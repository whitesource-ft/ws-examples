# Scripts
This repository contains scripts for use with WhiteSource Unified agent scanning within a CI/CD pipeline.

## [Adding Red Shield Comment Links to GitHub Issues](ghissue-eua.sh)
Add the following lines after the Unified Agent command in a GitHub action to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.

<br>
The following prequisites need to be met for the script to work
<br>

* ```jq awk``` must be installed
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

## [Adding Red Shield Comments Links to GitHub Issues & Closing Green Shield Issues](ghissue-prioritize.sh)
Add the following lines after the Unified Agent command in a GitHub action to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.  If a the vulnerability has a green shield a comment will be made, the issue will be closed, and the vulnerability will be ignored in WhiteSource.

<br>
The following prequisites need to be met for the script to work
<br>

* ```jq awk``` must be installed
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

## Reports Within a Pipeline

Any WhiteSource report can also be published as a part of the pipeline.
Add the following after calling the unified agent in any pipeline file to save reports from the scanned project to the whitesource logs folder then use your [pipeline publish](../CI-CD#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact

<br>
The following prequisites need to be met for the script to work
<br>

* ```jq awk``` must be installed
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


## Pipeline SBOM Generation

Add the following after calling the unified agent in any pipeline to create an SPDX tag value output from the scanned project to the whitesource logs folder then use your [pipeline publish](../CI-CD#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact

<br>
The following prequisites need to be met for the below example to work
<br>

* ```jq awk python3 python3-pip``` must be installed
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
