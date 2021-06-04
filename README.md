![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
# WhiteSource Examples
## Azure DevOps
- [Using WhiteSource Unified Agent in an NPM build pipeline](https://github.com/whitesource-ft/ws-examples/tree/main/AzureDevOps/npm)



# Language Specific Prioritize Examples
For all examples below, ensure that the branches defined within the .yml file are same as the branch where the file is going to be committed

##  [GitHub Actions](https://docs.github.com/en/actions)
YAML files beginning with "github"
* Add the yml file to a subfolder named workflows underneath the .github folder in the branch you would like to scan and adjust branch triggers (on:) within the yml file.
    * `.github/workflows/github-action.yml`
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page and "USERKEY" from your profile page

## [Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
YAML files containing "azure-pipelines"
* Ensure the default branch is the same as the .yml file or replace branch name in trigger.
* Create a new pipeline by selecting Pipelines>Create Pipeline>Azure Repos Git> your imported repository, then select starter pipeline and replace contents with the .yml file
* Add a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apikey" with your WhiteSource API Key from the integrate page & "userkey" from your profile page

## Branching
The default for many of these yml files is enabled to scan on every push & pull request to a release branch.  It is recommended to run prioritize on pull requests to a protected branch.  An example of this config for GitHub actions can be seen below

```
on:
  pull_request:
    branches: [ release* ]
```

## Pipeline Log Publishing

* Publish the whitesource logs by adding the following commands depending on each pipeline

### Azure DevOps Pipelines

```
- publish: $(System.DefaultWorkingDirectory)/whitesource
  artifact: Whitesource-Logs
```
### GitHub Actions

```
- name: 'Upload WhiteSource Logs'
  uses: actions/upload-artifact@v2
  with:
    name: Whitesource-Logs
    path: whitesource
    retention-days: 1
```

## Prioritize Troubleshooting
* Add -viaDebug true at the end of the unified agent command
* Publish the following folders using your pipeline publish tool - GitHub Action example below
  * /tmp/whitesource*
  * /tmp/ws-ua*

* Important items
  * App.json file will have the elementid & method that should be tracked down
  * log should tell you if java or jdeps is a problem
  * %TEMP% in Windows instead of /tmp/
#### GitHub Prioritize Log Publish
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

