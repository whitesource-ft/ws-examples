![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
# WhiteSource Examples
This repository contains examples of different ways to scan open source component using the [Unified Agent](https://whitesource.atlassian.net/wiki/spaces/WD/pages/804814917/Unified+Agent+Overview)

<br>

If you can't find something, use search to [search in this repository](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/about-searching-on-github)

<br>


## [CI-CD by Pipeline](CI-CD.md)

## [Generic by Use Case](Generic)

## [Prioritize Scans by Language](Prioritize/Prioritize-Examples.md)

## Useful Scripts

### [Prioritize Comments for GitHub Issues](Prioritize/Prioritize-Examples.md#Adding-Prioritize-Comment-Links-to-GitHub-Issues)


### [Automatic SBOM Creation](pipelineSBOM.sh)

Add the following after calling the unified agent in any pipeline file to create an SPDX tag value output from the scanned project to the whitesource logs folder
then use your [pipeline publish](CI-CD/CI-CD.md#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact
<br>
The following prequisites need to be met for the script to work
<br>
* ```jq curl python3 python3-pip``` must be installed
  * 99.9% of pipelines have these pre-installed
* the following environment variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY
  * WS_APIKEY

```
         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelineSBOM.sh
         chmod +x ./pipelineSBOM.sh && ./pipelineSBOM.sh WS_URL
```
WS_URL options: saas, saas-eu, app, app-eu

More information & usage regarding the [WS SBOM generator](https://github.com/whitesource-ps/ws-sbom-spdx-report)
