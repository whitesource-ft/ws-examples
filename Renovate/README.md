# Renovate Examples by CI/CD Tool
This repository contains examples of a Self-hosted instance of [Renovate](https://docs.renovatebot.com/) to generate automatic pull requests as part of various pipelines.

**Important Note - The following step is required for all integrations** 

It is highly recommend to configure a GitHub.com [Personal Access Token](https://github.com/settings/tokens) (with the scope repos) as GITHUB_COM_TOKEN so that your bot can make authenticated requests to GitHub.com for changelog retrieval as well as for any dependency that uses GitHub tags (without such a token, GitHub.com's API will rate limit requests and make such lookups unreliable).

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
* Create a new project to host the runner (e.g. renovate-runner-host).
* Add GITHUB_COM_TOKEN and RENOVATE_TOKEN to [CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/).
* Create a new main pipeline for the desired project and replace contents with the attached .gitlab-ci.yml file.
* Adjust RENOVATE_EXTRA_FLAGS to indicate what projects Renovate should run against -
  - If you wish for your bot to run against any project which the RENOVATE_TOKEN PAT has access to, but which already have a renovate.json or similar config file, then add this variable: RENOVATE_EXTRA_FLAGS: --autodiscover=true. This will mean no new projects will be onboarded.
  - However, we recommend you apply an autodiscoverFilter value like the following so that the bot does not run on any stranger's project it gets invited to: RENOVATE_EXTRA_FLAGS: --autodiscover=true --autodiscover-filter=group1/*. Checkout renovate docs for more information about gitlab security.
  - If you wish for your bot to run against every project which the RENOVATE_TOKEN PAT has access to, and onboard any projects which don't yet have a config, then add this variable: RENOVATE_EXTRA_FLAGS: --autodiscover=true --onboarding=true --autodiscover-filter=group1/*.
  - If you wish to manually specify which projects that your bot runs again, then add this variable with a space-delimited set of project names: RENOVATE_EXTRA_FLAGS: group1/repo5 user3/repo1.
* Set up a schedule (CI / CD > Schedules) to run Renovate regularly.
  - A good practise is to run it hourly. The following runs Renovate on the third minute every hour: 3 * * * *.
