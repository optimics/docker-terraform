# Docker: optimics/terraform

[![](https://badgen.net/github/checks/optimics/docker-terraform)](https://github.com/optimics/docker-terraform/actions)
[![](https://badgen.net/github/tag/optimics/docker-terraform)](https://github.com/optimics/docker-terraform/tags)
[![](https://badgen.net/docker/pulls/optimics/terraform)](https://hub.docker.com/r/optimics/terraform)
[![](https://badgen.net/docker/size/optimics/terraform)](https://hub.docker.com/r/optimics/terraform)

A fruitful image that puts together several tools to make Continuous Deliveries and Continuous Deployments on Bitbucket Pipelines easy.

* [git](https://git-scm.com/)
* [Google Cloud SDK](https://cloud.google.com/sdk/)
* [Node.JS](https://nodejs.org/) with [npm](https://www.npmjs.com/)
* [Terraform](https://www.terraform.io/cli/commands)
* [descope-env](./descope-env.sh)

## `descope-env`

A tiny script that removes scope from your variables. Use this if you have mixed environment variables set in your system. There is no need to do additional variable mapping, which can save your pipeline definition size.

```shell
export STAGING_MYSQL_PASSWORD=password123
descope-env staging
echo $MYSQL_PASSWORD
# password123
```

First argument to this script is the actual environment. If none is passed, descope-env considers it the staging environment. If the variable `BITBUCKET_TAG` contains semver tag, it is considered the production environment.
