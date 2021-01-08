# gitlab-auto-devops-terraform

Gitlab Auto DevOps using Terraform

# Getting started

1. create gitlab project
1. create deploy token with name `gitlab-deploy-token` and read registry permissions
1. push `.gitlab-ci.yml` file with content
1. when `Dockerfile` is created the autodevops pipeline will create `docker:build` job which will build docker image and push it to gitlab registry
1. by creating `deployment` folder with terraform files the autodevops pipeline will trigger deployment

## Docker builds

`.gitlab-ci.yml` file with content:

```
include:
  - project: "panaxeo-public/gitlab-auto-devops-terraform"
    file: "/ci/templates/auto-devops.gitlab-ci.yml"
```

## Terraform deployments

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
  source          = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-k8s-stack"
  name            = "ma-app" # optional, defaults to var.gitlab.ci_project_name
  container_image = var.ci_image
}
```

## Unlocking gitlab managed terraform state

```
STATE_URL=https://gitlab.com/api/v4/projects/<PROJECT_ID>/terraform/state/<STATE_NAME>/lock
PRIVATE_TOKEN=<MYTOKEN>
curl -X DELETE --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" $STATE_URL
```
