![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
# WhiteSource Examples
## Azure DevOps
- [Using WhiteSource Unified Agent in an NPM build pipeline](https://github.com/whitesource-ft/ws-examples/tree/main/AzureDevOps/npm)

# Language Specific Scan Examples
Files beginning with "github" are for [GitHub Actions](https://docs.github.com/en/actions).
* Add the yml file to a subfolder named workflows underneath the .github folder in the branch you would like to scan and adjust branch triggers (on:) within the yml file.
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page

Files labeled azure-pipelines.yml are for use with Azure DevOps and can be added directly to the repository.
* Add a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apikey" with your WhiteSource API Key from the integrate page

## Java

### [Security Shepherd](https://github.com/OWASP/SecurityShepherd)
A web application built with Maven using JDK 11.  Mobile application is currently excluded for the scan.

### [WebGoat](https://github.com/WebGoat/WebGoat)
A multi module web application built with Maven using JDK 11.

## DotNet

### [Umbraco-CMS](https://github.com/umbraco/Umbraco-CMS) 
A multi module web application built with .NET Framework 4.7.2 on a windows-latest image.
