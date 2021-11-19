# Prioritize Examples by Language
This repository contains language specific examples of different ways to scan using [WhiteSource Prioritize](https://whitesource.atlassian.net/wiki/spaces/WD/pages/1526530050/WhiteSource+Prioritize)

* [.NET](DotNet)
  * [Multi-Module](DotNet/Multi-Module)
  * [Single-Module](DotNet/Single-Module)
* [Java](Java)
  * [Multi-Module](Java/Multi-Module)
  * [Single-Module](Java/Single-Module)
* [Javascript](JavaScript)
* [Python](Python)
* [Scala](Scala)

For all examples above, make sure to change the branches defined within the .yml file according to your needs.  Refer to [Branching](#Branching) for best practices

**Important .NET Note** 
<br>
[xModuleAnalyzer](https://github.com/whitesource-ft/xModuleAnalyzer-NET) scripts may require some customization due to different build and exclusion types

##  [GitHub Actions](https://docs.github.com/en/actions)
YAML files beginning with "github-action"
* Add the yml file to a subfolder named workflows underneath the .github folder in the branch you would like to scan and adjust branch triggers (on:) within the yml file.
    * `.github/workflows/github-action.yml`
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page, "USERKEY" from your profile page, and update WS_WSS_URL if necessary

## [Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
YAML files containing "azure-pipelines"
* Create a new pipeline by selecting Pipelines>Create Pipeline>Azure Repos Git> your imported repository, then select starter pipeline and replace contents with the .yml file
* Add a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apiKey" with your WhiteSource API Key from the integrate page, "userKey" from your profile page, and update WS_WSS_URL if necessary

## [GitLab pipelines](https://docs.gitlab.com/ee/ci/pipelines/)
YAML files containing "gitlab-ci"
* Add the gitlab-ci.yml file to the root of your repository
* Add a [variable](https://docs.gitlab.com/ee/ci/variables/) named "APIKEY" with your WhiteSource API Key from the integrate page, "USERKEY" from your profile page, and update WS_WSS_URL if necessary

## Branching
The default for many of these yml files is enabled to scan on every push & pull request to a release branch.  It is recommended to run Prioritize on pull requests to a protected branch.  An example of this config for GitHub actions can be seen below

```
on:
  pull_request:
    branches: [ release* ]
```
## [Adding Prioritize Comment Links to GitHub Issues](../Scripts/README.md)

## Prioritize Troubleshooting
* Add ```-viaDebug true``` at the end of the Unified Agent command
* Publish the following folders using your pipeline publish tool, [GitHub Prioritize Log Publish example](#GitHub-Prioritize-Log-Publish)
  * /tmp/whitesource*
  * /tmp/ws-ua*
* For GitHub actions use ```continue-on-error: true``` in the Priortize step if the step is failing before the log publish

* Important items
  * App.json file will have the elementid & method that should be tracked down
  * The log should mention if java or jdeps is a problem
  * %TEMP% should be used in Windows instead of /tmp/
  
### GitHub Prioritize Log Publish
```
    - name: 'Upload Prioritize Logs'
      uses: actions/upload-artifact@v2
      with:
        name: Prioritize-Logs
        path: |
          ${{github.workspace}}/whitesource
          /tmp/whitesource*
          /tmp/ws-ua*
        retention-days: 1
```

### Single Folder Log Publish
If your pipeline publish does not allow for multi folder publishing like GitHub actions, then add the following script after your scan to copy all required folders to the whitesource folder. [AzureDevOps](../CI-CD#Azure-DevOps-Pipelines) is a good example where only single folder publishing is allowed.
```
if [ ! -d "/tmp/whitesource*" ] ; then cp /tmp/whitesource* ./whitesource ; else echo "/tmp/whitesource* does not exist" ; fi
if [ ! -d "/tmp/ws-ua*" ] ; then cp /tmp/whitesource* ./whitesource ; else echo "/tmp/ws-ua* does not exist" ; fi
```
