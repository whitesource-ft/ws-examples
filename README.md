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
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page

## [Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
YAML files containing "azure-pipelines"
* Ensure the default branch is the same as the .yml file or replace branch name in trigger.
* Create a new pipeline by selecting Pipelines>Create Pipeline>Azure Repos Git> your imported repository, then select starter pipeline and replace contents with the .yml file
* Add a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apikey" with your WhiteSource API Key from the integrate page

## Branching
The default for many of these yml files is enabled to scan on every push and is not recommended for production. It is recommended to run prioritize on pull requests to a protected branch.  An example of this config for GitHub actions can be seen below

```
on:
  pull_request:
    branches: [ release** ]
```