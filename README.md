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
* Add or update a [pipeline variable](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch) named "apikey" with your WhiteSource API Key from the integrate page
* For the aspnetcore-realworld-example-app application, do the following:
  * Fork a copy of https://github.com/gothinkster/aspnetcore-realworld-example-app (don't use the original repo because we need to create a pipeline file within it)
  * Create an AzDO project, and a pipeline within it that gets its source from your GitHub fork above.
  * Change the URL on the "git clone" line (currently line 39) of azure-pipelines.yml to point to your fork.
  * Change the WS_APIKEY variable (currently line 18) in azure-pipelines.yml to your API key
  * Run the pipeline.  The scan should show up in saas.whitesourcesoftware.com under the "My Product" product.  (You can also add a product name in the WhiteSource command line.)

## Java

### [Security Shepherd](https://github.com/OWASP/SecurityShepherd)
A web application built with Maven using JDK 11.  Mobile application is currently excluded for the scan.

### [WebGoat](https://github.com/WebGoat/WebGoat)
A multi module web application built with Maven using JDK 11.

## DotNet

### [Umbraco-CMS](https://github.com/umbraco/Umbraco-CMS)
A multi module web application built with .NET Framework 4.7.2 on a windows-latest image.
