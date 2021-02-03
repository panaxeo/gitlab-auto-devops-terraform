# Gitlab Auto DevOps using Terraform

Gitlab Autodevops features offers great set of tools to automate deployment and monitoring processes for kubernetes stacks. This project aims to provide similar features using Terraform. This brings more flexibility from IaC point of view as You can start focusing on deployment of infrastructure needed for You service as well (eg. S3 bucket, RDS instance, standalone redis service, custom ingress configuration, ...).

# Getting started

### Kubernetes cluster setup

This project aims to support default kubernetes installation so all You need to do is register cluster to gitlab by following standard process described at [Gitlab kubernetes clusters docs](https://docs.gitlab.com/ee/user/project/clusters/add_remove_clusters.html#create-new-cluster).

Please note that for exposing the running services You need to install Gitlab managed apps:

- ingress controller
- cert-manager

You can also install Your own ingress controller as using Gitlab approach creates load balancer which may incur additional costs

_Note: Gitlab managed apps can be installed using UI in cluster management or using cluster management project. You can find more information at [Gitlab Managed Apps docs](https://docs.gitlab.com/ee/user/clusters/applications.html)_

### Project setup

Before You get started with the deployment, there are few steps that You need to go through to prepare Your gitlab projects for deployment:

1. create gitlab project
1. create deploy token with name `gitlab-deploy-token` and read registry permissions (Settings > Repository > Deploy tokens)
1. push `.gitlab-ci.yml` file with content (see Pipeline configuration)[#pipeline-configuration]
1. (optional) create `Dockerfile` to enable build job which creates docker image and push image to gitlab registry
1. create `deployment` folder to enable deployment jobs which will trigger terraform deployment. For more information see [Terraform deployments](#terraform-deployments)

## Pipeline configuration

`.gitlab-ci.yml` file with content:

```
include:
  - project: "panaxeo-public/gitlab-auto-devops-terraform"
    file: "/ci/templates/auto-devops.gitlab-ci.yml"
```

_Note: the autodevops template is composition of other templates, so feel free to customize it to Your needs_

## Terraform deployments

To enable deployment jobs the `/deployment` folder needs to exist and contain some Terraform files.

To enable Gitlab docker registry access and propagation of secrets defined in project configuration (CI/CD variables), base resources needs to be created.

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

To deploy application to kubernetes cluster, create another terraform file (eg `main.tf`) with content:

```
module "k8s-app" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-k8s-stack"
  gitlab = var.gitlab

  # hostname = replace(var.gitlab.ci_environment_url, "https://", "")
}

```

For full example see [Full examples section](./docs/full-examples.md)

### Handling secrets

Using `K8S_SECRET` prefix is supported in similar fasion as in Gitlab autodevops (using environment variables). You can find more information here:
[Secret docs](./docs/secrets.md)

### Cron jobs

Terraform module for easily creaing kubernetes cronjob is prepared under `gitlab-cron-job`. You can find more information here:
[Cron jobs docs](./docs/cron-jobs.md)

### Deploying with other terraform providers

- only providers in terraform registry are supported as they are downloaded adhoc
- make sure You have each provider properly configured (ideally using environment variables)
