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

First argument to this script is the actual environment. It can be omitted and passed as `PROJECT_ENVIRONMENT` env variable instead. If none is set, descope-env considers it the staging environment. If the variable `BITBUCKET_TAG` contains semver tag, it is considered the production environment.

### with package.json

Given `package.json` is present in the working directory, the `descope-env` will apply any key/value pairs from the `env` section into current environment.

## `init-gcs`

Also a tiny script that initializes Terraform Google Cloud Storage Backend and sets up a service account based on the credentials stored in `TF_VAR_GOOGLE_CREDENTIALS`. It takes no arguments. Make sure the `TF_VAR_BUCKET_TERRAFORM` contains the terraform state bucket.

## Usage

```
definitions:
  steps:
    - step: &deploy
        name: Deploy Infrastructure
        image: optimics/terraform:0.4
        script:
          - . descope-env
          - init-gcs
          - terraform validate
          - terraform apply --input=false --auto-approve

  branches:
    master:
      - step: *deploy

  tags:
    'v*':
      - step: *deploy
```
