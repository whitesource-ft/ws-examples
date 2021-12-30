# Examples by CI/CD Tool
This repository contains tool specific examples of how to scan using the WhiteSource Unified Agent within a CI/CD pipeline.

* [AzureDevOps](AzureDevOps)
* [Bitbucket](Bitbucket)
* [CodeFresh](CodeFresh)
* [CircleCI](CircleCI)
* [GitHub](GitHub)
* [GitLab](GitLab)
* [GoogleCloudBuild](GoogleCloudBuild)
* [Jenkins](Jenkins)


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

## [WhiteSource Report Publishing](../Scripts/README.md)