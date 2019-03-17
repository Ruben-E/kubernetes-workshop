# Setup

## Make yourself cluster-admin
```
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)
```

## Create user
```
./new-workshop-user.sh <name>
```

## Delete user
```
./delete-workshop-user.sh <name>
````
