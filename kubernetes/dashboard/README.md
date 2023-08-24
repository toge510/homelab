## Deploy and Access the Kubernetes Dashboard

Dashboard is a web-based Kubernetes user interface. 

### Deploying the Dashboard with Helm

```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
```

```
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard --version 6.0.8 -f custom-values.yaml 
```

Use `custom-values.yaml ` so that the EXTERNAL-IP (192.168.11.240) can be assigned to kubernetes-dashboard load balancer service by metalLB.

```
service:
  type: LoadBalancer
  annotations:
    metallb.universe.tf/loadBalancerIPs: 192.168.11.240
```

Create a new user using the Service Account mechanism of Kubernetes, grant this user admin permissions and login to Dashboard using a bearer token tied to this user.

Follow [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md).

You can get a Bearer Token with `kubectl -n kubernetes-dashboard create token admin-user`, but 
> A token served for a TokenRequest expires either when the pod is deleted or after a defined lifespan (by default, that is 1 hour).

To create a non-expiring, persisted API token for a ServiceAccount, create a Secret of type kubernetes.io/service-account-token with an annotation referencing the ServiceAccount.

```
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: admin-user-secret
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
```

Get a bearer token

```
kubectl -n kubernetes-dashboard get secrets admin-user-secret -o jsonpath='{.data.token}' | base64 -d
```

### Accessing the Dashboard UI

The EXTERNAL-IP (192.168.11.240) can be assigned to kubernetes-dashboard load balancer service by metalLB.

```
goto@homelab:$ kubectl -n kubernetes-dashboard get svc kubernetes-dashboard 
NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)         AGE
kubernetes-dashboard   LoadBalancer   10.102.243.248   192.168.11.240   443:31421/TCP   30m
```

Access `192.168.11.240` and login with the above token.


### _References_
* [kubernetes-dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard/6.0.8)
* [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)
* [Deploy and Access the Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
* [Create additional API tokens](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#create-token)