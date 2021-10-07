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
## Adding Prioritize Comment Links to GitHub Issues
Add the following lines after the Unified Agent command to add comments to your GitHub issues that are created by the WhiteSource GitHub integration.  These comments will indicate if the vulnerability has a redshield and provide a link to the WhiteSource UI for further examination.
```
curl -LJO https://raw.githubusercontent.com/whitesource-ft/ws-examples/main/ghissue-eua.sh 
chmod +x ./ghissue-eua.sh && ./ghissue-eua.sh saas
```

## Prioritize Troubleshooting
* Add ```-viaDebug true``` at the end of the Unified Agent command
* Publish the following folders using your pipeline publish tool, [GitHub Prioritize Log Publish example](#GitHub-Prioritize-Log-Publish)
  * /tmp/whitesource*
  * /tmp/ws-ua*

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
          /tmp/whitesource*
          /tmp/ws-ua*
        retention-days: 1
```

