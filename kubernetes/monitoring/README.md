```mermaid
graph LR;
  client([client])-. Ingress-managed <br> load balancer .->ingress[Ingress, 192.168.11.245];
  ingress-->|/monitoring/prometheus/graph|service1[Service: prometheus-kube-prometheus-prometheus:9090];
  ingress-->|/monitoring/grafana/login|service2[Service: prometheus-grafana:80];
  ingress-->|/monitoring/alertmanager|service3[Service: prometheus-kube-prometheus-alertmanager:9093];
  subgraph cluster, namespace:monitoring
  ingress;
  service1
  service2
  service3
  end
  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
  class ingress,service1,service2,service3 k8s;
  class client plain;
  class cluster cluster;
```
