# Vault Work

## Logging Into Vault

There are 2 methods by which we can login to vault:

1) [github auth method]

`vault login -method=github -path="smpl-cloud" token="$TOKEN"`

2) [Via the CLI] using the [cloud auth method]

```bash
vault login -method=gcp \
    role="my-role" \
    service_account="authenticating-account@my-project.iam.gserviceaccount.com" \
    project="my-project" \
    jwt_exp="15m" \
    credentials=@path/to/signer/credentials.json
```


[github auth method]:https://www.vaultproject.io/docs/auth/github
[cloud auth method]:https://www.vaultproject.io/docs/auth/gcp
[Via the CLI]:https://www.vaultproject.io/docs/auth/gcp#via-the-cli-helper