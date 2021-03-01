![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
# WhiteSource Examples
## Azure DevOps
- [Using WhiteSource Unified Agent in an NPM build pipeline](https://github.com/whitesource-ft/ws-examples/tree/main/AzureDevOps/npm)

# Language Specific Scan Examples
For all examples below, ensure that the branches defined within the .yml file are same as the branch where the file is going to be committed

## [Native Repo Integrations](https://whitesource.atlassian.net/wiki/spaces/WD/pages/820183063/Repo+Integrations)
Whitesource.config files

* When a whitesource.config file example exists, you can change [configMode](https://whitesource.atlassian.net/wiki/spaces/WD/pages/697696422/WhiteSource+for+GitHub.com#WhiteSourceforGitHub.com-ScanSettings(scanSettings)) to "LOCAL" and add the file for optimal results with the repo integration
##  [GitHub Actions](https://docs.github.com/en/actions)
YAML files beginning with "github"
* Add the yml file to a subfolder named workflows underneath the .github folder in the branch you would like to scan and adjust branch triggers (on:) within the yml file.
    * `.github/workflows/github-wsprioritize-maven.yml`
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page

## [Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
YAML files containing "azure-pipelines"
* Ensure the default branch is the same as the .yml file by selecting Repo>Branches followed by the ellipsis on the branch name & "Set as default branch"
* Create a new pipeline by selecting Pipelines>Create Pipeline>Azure Repos Git> your imported repository, then select starter pipeline and replace contents with the .yml file
* Add a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apikey" with your WhiteSource API Key from the integrate page

## Java

Repository | Package Manager | Environment | Branch
---------- | --------------- | ----------- | ------
[Security Shepherd](https://github.com/OWASP/SecurityShepherd) | Maven | JDK 11 / ubuntu-latest | dev
[WebGoat](https://github.com/WebGoat/WebGoat) | Maven | JDK 11 / ubuntu-latest | develop

## .NET

Repository | Package Manager | Environment | Branch
---------- | --------------- | ----------- | ------
[aspnetcore-realworld-example-app](https://github.com/gothinkster/aspnetcore-realworld-example-app) | Nuget | .NET Core 3.1 / ubuntu-latest | 93ed4ba61b600509b62ace9cf57d3c7ccb9f2c96
[Umbraco-CMS](https://github.com/umbraco/Umbraco-CMS) | Nuget | .NET 4.7.2 / windows-latest | v8/8.9
