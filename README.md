![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
# WhiteSource Examples
This repository contains examples of different ways to scan open source component using the [Unified Agent](https://whitesource.atlassian.net/wiki/spaces/WD/pages/804814917/Unified+Agent+Overview)
## [Azure DevOps](AzureDevOps)
- [Using WhiteSource Unified Agent in an NPM build pipeline](https://github.com/whitesource-ft/ws-examples/tree/main/AzureDevOps/npm)

## [Language Specific Prioritize Examples](Prioritize/Prioritize-Examples.md)

## [Generic Unified Agent Examples](Generic)

## Langauge Specific Unified Agent Examples
### [Android](Android)
### [Swift](Swift)

## Pipeline Log Publishing

* Publish the `whitesource` folder with logs & reports by adding the following commands depending on each pipeline

### Azure DevOps Pipelines

```
- publish: $(System.DefaultWorkingDirectory)/whitesource
  artifact: Whitesource
```
### GitHub Actions

```
- name: 'Upload WhiteSource folder'
  uses: actions/upload-artifact@v2
  with:
    name: WhiteSource
    path: whitesource
    retention-days: 1
```