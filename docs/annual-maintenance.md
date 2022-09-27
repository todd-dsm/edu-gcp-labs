# Annual Maintenance

## Cluster Certs

After updating the [cluster certs], update them in Vault as well. Ensure the correct environment; the new cert value can be found by:

```bash
kubeAPI="$(kubectl cluster-info | grep "Kubernetes master" | \
    awk '{print $NF}')"
defaultToken=$(kubectl get secrets | grep default | awk '{print $1}')
caCert=$(kubectl get secret "${defaultToken}" \
    -o jsonpath="{['data']['ca\\.crt']}" | base64 --decode)
# Get SA Token to use for retrieval of the SA JWT
kubesSAToken="$(kubectl get serviceaccounts $kubesSAVaultAcct \
    -o jsonpath='{.secrets[].name}')"
kubesSAJWT="$(kubectl get secret "$kubesSAToken" \
    -o jsonpath='{.data.token}'  | base64 --decode)"
```

Drop this in Vault:

```bash
vault write auth/kubernetes/config   \                                           
   token_reviewer_jwt="$kubesSAJWT"  \                                         
   kubernetes_host="${kubeAPI}:8443" \                                        
   kubernetes_ca_cert="$caCert"
```

[cluster certs]:https://github.com/smpl-cloud/infras-boomtopia/blob/master/scripts/vault-conf.sh#L141-L148