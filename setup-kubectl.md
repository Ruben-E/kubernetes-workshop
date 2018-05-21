# Setup kubectl on your local machine

```
kubectl config set-cluster kubernetes-workshop --server=<server> --insecure-skip-tls-verify=true
kubectl config set-context kubernetes-workshop-context --cluster=kubernetes-workshop --user=<username> --namespace=<username>
kubectl config set-credentials <username> --token=<token>
kubectl config use-context kubernetes-workshop-context
```

