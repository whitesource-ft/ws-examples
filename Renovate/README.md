# Renovate Examples by CI/CD Tool
This repository contains examples of a Self-hosted instance of [Renovate](https://docs.renovatebot.com/) to generate automatic pull requests as part of various pipelines.

For all examples above, make sure to change the branches defined within the .yml file according to your needs.  Refer to [Branching](#Branching) for best practices

**Important Note - The following step is required for all integrations** 

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
* Set a [Personal Access Token](https://gitlab.com/-/profile/personal_access_tokens) as RENOVATE_TOKEN for the bot account (scopes: read_user, api and write_repository).
* Create a new pipeline for the desired project and replace contents with the attached gitlab-ci.yml file.
* Add GITHUB_COM_TOKEN and RENOVATE_TOKEN to [CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/).

