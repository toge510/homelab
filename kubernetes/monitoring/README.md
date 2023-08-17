## [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

## Install

```
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

There are 3 deployments:

* prometheus-grafana - This is the grafana instance that gets deployed with the helm chart.
* prometheus-kube-prometheus-operator - Responsible for deploying & managing the prometheus instance.
* prometheus-kube-state-metrics - Collects cluster level metrics (pods, deployments, etc).

There are 2 statefulsets:

* prometheus-prometheus-kube-prometheus-prometheus - This is the prometheus instance.
* alertmanager-prometheus-kube-prometheus-alertmanager - This is the alertmanager instance.* 

## Ingress

Ingress can expose HTTP rutes from outside the cluster to services within cluster. Traffic routing is controlled by rules defined on the Ingress resource (`ingress.yaml`).

```
kubectl apply -f ingress.yaml
```

The ingress resource would control the traffic routing as shown below.

```mermaid
graph LR;
  client([client])-. Ingress-managed <br> load balancer .->ingress[Ingress, 192.168.11.245];
  ingress-->|/monitoring/prometheus/graph|service1[Service: prometheus-kube-prometheus-prometheus:9090];
  ingress-->|/monitoring/grafana/login|service2[Service: prometheus-grafana:80];
  ingress-->|/monitoring/alertmanager|service3[Service: prometheus-kube-prometheus-alertmanager:9093];
  ingress-->|/monitoring/api/|service4[Service: api-service:3000];
  subgraph cluster, namespace:monitoring
  ingress;
  service1
  service2
  service3
  service4
  end
  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
  class ingress,service1,service2,service3,service4 k8s;
  class client plain;
  class cluster cluster;
```

## _References_

* [Wiki: Installs kube‐prometheus stack](https://github.com/toge510/homelab/wiki/Installs-kube%E2%80%90prometheus-stack)
* [Wiki: Ingress Resource](https://github.com/toge510/homelab/wiki/Ingress-Resource)
* [Ingress-nginx: REWRITE](https://github.com/kubernetes/ingress-nginx/blob/main/docs/examples/rewrite/README.md)