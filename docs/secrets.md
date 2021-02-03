# Secrets

All secrets with prefix `K8S_SECRET_` are automatically deployed to kubernetes secret named `gitlab-secrets`. You can reference these secrets by `secrets` variable:

```
# Assuming You have configured K8S_SECRET_DATABASE_URL in Your CI/CD Variables config

module "k8s-app" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-k8s-stack"
  gitlab = var.gitlab

  secrets = [{
    name        = "DATABASE_URL"
    secret_name = "gitlab-secrets"
    secret_key  = "DATABASE_URL"
  }]
}

```

More information about the `K8S_SECRET_` prefix and usage in Gitlab can be found here: [Application secret variables](https://docs.gitlab.com/ee/topics/autodevops/customize.html#application-secret-variables)
