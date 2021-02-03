# Cron jobs

You can create kubernetes cron jobs using `k8s-cron-jov` with similar configuration (environment variables and secrets) as in case of `gitlab-k8s-stack` module.

```
module "k8s-app" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-cron-job"
  schedule = "*/5 * * * *"
}
```

For full example see [Full examples section](./docs/full-examples.md#cron-job)
