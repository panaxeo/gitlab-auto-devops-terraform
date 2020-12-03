# gitlab-auto-devops-terraform

Gitlab Auto DevOps using Terraform

## Unlocking gitlab managed terraform state

```
STATE_URL=https://gitlab.com/api/v4/projects/<PROJECT_ID>/terraform/state/<STATE_NAME>/lock
PRIVATE_TOKEN=<MYTOKEN>
curl -X DELETE --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" $STATE_URL
```
