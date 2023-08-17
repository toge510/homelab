## Apply a simple app to be monitored

```
kubectl apply -f api.yaml
```

## Ingress

Append the following part to `monitoring/ingress.yaml`

```
  - http:
      paths:
      - backend:
          service:
            name: api-service
            port:
              number: 3000
        path: /monitoring/api(/|$)(.*)
        pathType: Prefix
```

Apply `monitoring/ingress.yaml`.

```
kubectl apply -f monitoring/ingress.yaml
```

```mermaid
graph LR;
  client([client])-. Ingress-managed <br> load balancer .->ingress[Ingress, 192.168.11.245];
  ingress-->|/monitoring/api/|service4[Service: api-service:3000];
  subgraph cluster, namespace:monitoring
  ingress;
  service4
  end
  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
  class ingress,service4 k8s;
  class client plain;
  class cluster cluster;
```

```
$ curl 192.168.11.245/monitoring/api/swagger-stats/metrics

# TYPE nodejs_process_memory_rss_bytes gauge
nodejs_process_memory_rss_bytes 57016320

# HELP nodejs_process_memory_heap_total_bytes Node.js process memory heapTotal bytes
# TYPE nodejs_process_memory_heap_total_bytes gauge
nodejs_process_memory_heap_total_bytes 15126528
.
.
```

## Add a target 

With the prometheus operator, you can declaratively define all the endpoints prometheus should scrape by creating a ServiceMonitor. Prometheus will automatically pickup all targets to scrape from the defined ServiceMonitors.

ServiceMonitors are a Custom Resource Definition provided by the Prometheus Operator.

* `kubectl get crd`:  
  see all of the CRDs provided by the Prometheus Operator.
* `kubectl get serviceMonitor`:  
  take a look at all of the ServiceMonitors that have been deployed. You can see a separate ServiceMonitor for each of the targets prometheus has already been configured to scrape.

Deploy a service monitor for api.

```
kubectl apply -f api-service-monitor.yaml
```

* `kind`: set to ServiceMonitor
* `selector.matchLabels`: a selector label to tell prometheus which service to scrape. We will need to match the label of our api-service.
* `spec.endpoints`: has scrape configurations for prometheus.
  * `interval`: equivalent to scrape_interval.
  * `port`: reference the name of the specific port in our service.
  * `path`: specific path that will expose metrics in the container, equivalent to metrics_path config.

You must find `api-service-monitor` under targets on Prometheus UI and query something about api app (ex. `api_request_total`).

## Add recording-rules and alerts

You can take a look at all of the pre-existing rules by running `kubectl get prometheusrules.monitoring.coreos.com` command.  
To create rules, we will define a new prometheus rules object (`monitoring/rules.yaml`).

PrometheusRule objects needs to have a specific label (`release: prometheus`) assigned to it so that the Prometheus instance can discover it.

You can cehck `ruleSelector` at the `Prometheus CRD` configuration. `ruleSelector` will have the label that the prometheus instance will look for. 

```
$ kubectl get prometheus -o yaml | grep -A 3 -i ruleSelector
    ruleSelector:
      matchLabels:
        release: prometheus
    scrapeConfigNamespaceSelector: {}
```

Apply `monitoring/rules.yaml`.

```
kubectl apply -f rules.yaml
```

You must find `node-example` under rules on Prometheus UI.

## Alertmanager config

The prometheus Operator has an AlertmanagerConfig CRD that is used for adding rules to alertmanager (`alertmanager-rule.yaml`).

```
kubectl apply -f alertmanager-rule.yaml
```

**Note: the syntax of the k8s rexource: `kind: AlertmanagerConfig` is different from the one of Prometheus config file.**  
Please refer [monitoring.coreos.com_alertmanagerconfigs.yaml](https://github.com/prometheus-operator/prometheus-operator/blob/main/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml) and [AlertmanagerConfig [monitoring.coreos.com/v1alpha1]](https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanagerconfig-monitoring-coreos-com-v1alpha1.html).

## _References_

* [rometheus-operator](https://github.com/prometheus-operator/prometheus-operator)