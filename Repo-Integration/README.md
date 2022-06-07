![Logo](https://whitesource-resources.s3.amazonaws.com/ws-sig-images/Whitesource_Logo_178x44.png)  

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![GitHub release](https://img.shields.io/github/release/whitesource-ft/ws-template.svg)](https://github.com/whitesource-ft/ws-template/releases/latest)  
# Repository Integration Automation Scripts
When used, these scripts will stand up a new repository integration environment in Docker.<BR />
- Repository Agent
- Remediate Server
- Controller
- Scanner

## Supported Operating Systems
- **Linux (Bash):**	CentOS, Debian, Ubuntu, RedHat

## Prerequisites
- Docker, Docker Compose, jq, GIT, WGET, SCM Repository instance up and running

## Options
setup.sh options: **ghe**, **gls**, **bb**

Options Defined:<BR />
**ghe** - Github Enterprise<BR />
**gls** - Gitlab <BR />
**bb** - Bitbucket On-Prem

## Execution
Execution instructions:  
git clone https://github.com/whitesource-ft/ws-examples.git && cd ws-examples/Repo-Integration<BR />
export ws_key='&lt;your-activation-key&gt;'<BR />
chmod +x ./setup.sh && ./setup.sh gls<BR />
docker-compose up<BR />
