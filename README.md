# gitlab-auto-devops-terraform

Gitlab Auto DevOps using Terraform

# Getting started

1. create gitlab project
1. create deploy token with name `gitlab-deploy-token` and read registry permissions
1. push `.gitlab-ci.yml` file with content
1. (optional) create `Dockerfile` to enable build job which creates docker image and push image to gitlab registry
1. create `deployment` folder to enable deployment jobs which will trigger terraform deployment. For more information see [#terraform-deployments](Terraform deployments)

## Docker builds

`.gitlab-ci.yml` file with content:

```
include:
  - project: "panaxeo-public/gitlab-auto-devops-terraform"
    file: "/ci/templates/auto-devops.gitlab-ci.yml"
```

## Terraform deployments

To enable

Create `deployment/base.tf` file with following content:

```
terraform {
  backend "http" {}
  required_version = ">= 0.13"
}

provider "kubernetes" {}

variable "gitlab" {}

module "gitlab-secret" {
  source    = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-registry-k8s-secret"
  gitlab    = var.gitlab
}
```

to deploy application to kubernetes cluster, create another terraform file (eg `main.tf`) with content:

```
module "k8s-app" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-k8s-stack"
  gitlab = var.gitlab

  # hostname = replace(var.gitlab.ci_environment_url, "https://", "")
}

```

### Handling secrets

Using K8S_SECRET prefix for environment variables. More info here:
https://docs.gitlab.com/ee/topics/autodevops/customize.html#application-secret-variables

### Cron jobs

TODO

### Deploying with other terraform providers

- only providers in terraform registry are supported
- make sure You have environment variable properly configured

## Unlocking gitlab managed terraform state

```
STATE_URL=https://gitlab.com/api/v4/projects/<PROJECT_ID>/terraform/state/<STATE_NAME>/lock
PRIVATE_TOKEN=<MYTOKEN>
curl -X DELETE --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" $STATE_URL
```
