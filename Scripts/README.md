# Scripts
This repository contains scripts for use with WhiteSource Unified agent scanning within a CI/CD pipeline.

## [Adding Red Shield Comment Links to GitHub Issues](ghissue-eua.sh)
Add the following lines after the Unified Agent command to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.
<br>
The following prequisites need to be met for the script to work
<br>

* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_PRODUCTNAME
  * WS_PROJECTNAME

```
curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/Scripts/ghissue-eua.sh 
chmod +x ./ghissue-eua.sh && ./ghissue-eua.sh saas
```
WS_URL options: saas, saas-eu, app, app-eu

## [Adding Red Shield Comments Links to GitHub Issues & Closing Green Shield Issues](ghissue-prioritize.sh)
Add the following lines after the Unified Agent command to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.  If a the vulnerability has a green shield a comment will be made, the issue will be closed, and the vulnerability will be ignored in WhiteSource.
<br>
The following prequisites need to be met for the script to work
<br>

* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_PRODUCTNAME
  * WS_PROJECTNAME
  * WS_APIKEY

```
curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/Scripts/ghissue-prioritize.sh 
chmod +x ./ghissue-prioritize.sh && ./ghissue-prioritize.sh saas
```
WS_URL options: saas, saas-eu, app, app-eu

## [Automatic Reports Within a Pipeline](pipelinereports.sh)

Add the following after calling the unified agent in any pipeline file to save reports from the scanned project to the whitesource logs folder then use your pipeline publish feature to save the whitesource log folder as an artifact as shown in the README
<br>
The following prequisites need to be met for the script to work
<br>

* ```jq curl``` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY

```
         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelinereports.sh
         chmod +x ./pipelinereports.sh && ./pipelinereports.sh WS_URL
         
```
WS_URL options: saas, saas-eu, app, app-eu

## [Automatic SBOM Creation](pipelineSBOM.sh)

Add the following after calling the unified agent in any pipeline file to create an SPDX tag value output from the scanned project to the whitesource logs folder then use your [pipeline publish](CI-CD/CI-CD.md#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact
<br>
The following prequisites need to be met for the script to work
<br>

* ```jq curl python3 python3-pip``` must be installed
  * 99.9% of pipelines have these pre-installed
* ENV variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_APIKEY

```
         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/Scripts/pipelineSBOM.sh
         chmod +x ./pipelineSBOM.sh && ./pipelineSBOM.sh WS_URL
```
WS_URL options: saas, saas-eu, app, app-eu

More information & usage regarding the [WS SBOM generator](https://github.com/whitesource-ps/ws-sbom-spdx-report)
