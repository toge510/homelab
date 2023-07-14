## MetalLB

[MetalLB](https://metallb.universe.tf/) provides a network load-balancer implementation for Kubernetes clusters that do not run on a supported cloud provider, effectively allowing the usage of LoadBalancer Services within any cluster.

```
flowchart LR
    MetalLB --> loadBalancer Service
```

### Deploy

```
kubectl apply -f ipaddresspool.yaml 
kubectl apply -f l2advertisement.yaml
```

`.spec.addresses` defines the IP addresses to assign to the load balancer services. 

```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.11.240-192.168.11.250
```

Use the following annotation if you want to specify the IP address of load balancer service.

```
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
  annotations:
    metallb.universe.tf/loadBalancerIPs: 192.168.11.240
```

### Wiki

* [Wiki: MetalLB](https://github.com/toge510/homelab/wiki/MetalLB)