## Deploy and Access the Kubernetes Dashboard

Dashboard is a web-based Kubernetes user interface. 

### Deploying the Dashboard

Download the manifest file.

```
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

Update Service as Load balancer type

Deploy the Dashboard

```
kubectl apply -f recommended.yaml
```

### Accessing the Dashboard UI


### _References_
* [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)
* [Deploy and Access the Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)