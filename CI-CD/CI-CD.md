# Examples by CI/CD Tool
This repository contains tool specific examples of how to scan using the WhiteSource Unified Agent within a CI/CD pipeline.

* [AzureDevOps](AzureDevops)
* [CircleCI](CircleCI)
* [GitHub](GitHub)
* [GitLab](GitLab)
* [GoogleCloudBuild](GoogleCloudBuild)
* [Jenkins](Jenkins)


## Pipeline Log Publishing

* Publish the `whitesource` folder with logs & reports by adding the following commands depending on each pipeline

### Azure DevOps Pipelines

```
- publish: $(System.DefaultWorkingDirectory)/whitesource
  artifact: Whitesource
```
### GitHub Actions

```
- name: 'Upload WhiteSource folder'
  uses: actions/upload-artifact@v2
  with:
    name: WhiteSource
    path: whitesource
    retention-days: 1
```

## [WhiteSource Report Publishing](../pipelinereports.sh)

Any WhiteSource report can also be published as a part of the pipeline. An example of three different reports being published is linked above.  In order to have reports attached to each pipeline add the following after calling the unified agent in any pipeline file to save these reports to the whitesource logs folder
then use your [pipeline publish](CI-CD/CI-CD.md#Pipeline-Log-Publishing) feature to save the whitesource log folder as an artifact
<br>
The following prequisites need to be met for the script to work
<br>
* ```jq curl``` must be installed
  * 99.9% of pipelines have these pre-installed
* the following environment variables must be set
  * WS_GENERATEPROJECTDETAILSJSON: true
  * WS_USERKEY

```
         curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/pipelinereports.sh
         chmod +x ./pipelinereports.sh && ./pipelinereports.sh WS_URL
```
WS_URL options: saas, saas-eu, app, app-eu