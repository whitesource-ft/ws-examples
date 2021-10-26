# Renovate Examples by CI/CD Tool
This repository contains examples of a Self-hosted instance of [Renovate](https://docs.renovatebot.com/) to generate automatic pull requests as part of various pipelines.

For all examples above, make sure to change the branches defined within the .yml file according to your needs.  Refer to [Branching](#Branching) for best practices

**Important Note - The following step is required for all integrations** 
<br>
It is highly recommend to configure to configure a GitHub.com [Personal Access Token](https://github.com/settings/tokens) (with the scope repos) as GITHUB_COM_TOKEN so that your bot can make authenticated requests to GitHub.com for changelog retrieval as well as for any dependency that uses GitHub tags (without such a token, GitHub.com's API will rate limit requests and make such lookups unreliable).

## [Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
* Set a [Personal Access Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) as RENOVATE_TOKEN for the bot account.
* Create a new pipeline for the desired project and replace contents with the attached azure-pipelines.yml file.
* Add GITHUB_COM_TOKEN and RENOVATE_TOKEN as [Environment variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch)
* Update the RENOVATE_ENDPOINT to match your ADO organization (e.g. https://dev.azure.com/MyOrg).

## [Bitbucket pipelines](https://support.atlassian.com/bitbucket-cloud/docs/configure-bitbucket-pipelinesyml/)
*  Set an [App password](https://bitbucket.org/account/settings/app-passwords/) as RENOVATE_PASSWORD for the bot account.
*  Create a new pipeline for the desired project and replace contents with the attached bitbucket-pipelines.yml file.
*  Add GITHUB_COM_TOKEN and RENOVATE_PASSWORD as [Environment variables](https://support.atlassian.com/bitbucket-cloud/docs/variables-and-secrets/)

## [GitLab pipelines](https://docs.gitlab.com/ee/ci/pipelines/)
YAML files containing "gitlab-ci"
* Add the gitlab-ci.yml file to the root of your repository
* Add a [variable](https://docs.gitlab.com/ee/ci/variables/) named "APIKEY" with your WhiteSource API Key from the integrate page, "USERKEY" from your profile page, and update WS_WSS_URL if necessary






##  [GitHub Actions](https://docs.github.com/en/actions)
YAML files beginning with "github-action"
* Add the yml file to a subfolder named workflows underneath the .github folder in the branch you would like to scan and adjust branch triggers (on:) within the yml file.
    * `.github/workflows/github-action.yml`
* Add a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets) named "APIKEY" to the repository with your WhiteSource API Key from the Integrate page, "USERKEY" from your profile page, and update WS_WSS_URL if necessary



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

