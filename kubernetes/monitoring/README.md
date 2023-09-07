# kube-prometheus-stack

Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

* [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
* [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)

## Install with Helm

Install `kube-prometheus-stack`.

```
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace -f custom-values.yaml
```

You can run `helm -n monitoring get manifest prometheus | kubectl get -f -` command to see all the objects created.

Upgrade `kube-prometheus-stack` after updating `custom-values.yaml`

```
helm -n monitoring upgrade prometheus prometheus-community/kube-prometheus-stack -f custom-values.yaml
```

Access Prometheus UI on `localhost:9090` after running the following command.

```
kubectl -n monitoring port-forward prometheus-prometheus-kube-prometheus-prometheus-0 9090
```

Check this wiki: [Installs kube‐prometheus stack](https://github.com/toge510/homelab/wiki/Installs-kube%E2%80%90prometheus-stack) if some targets are down.

<br>

## Create Ingress resource

Create ingress resource to make `prometheus-grafana` service accessible from the outside.

```mermaid
graph LR;
  client([client])-. metalLB <br> Ingress-managed <br> load balancer .->ingress[Ingress, homelab.net];
  ingress-->|/grafana/|service4[Service: prometheus-grafana:80];
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

Define the following part in `custom-values.yaml`.

```
grafana:
  grafana.ini:
    server:
      domain: homelab.net
      root_url: "%(protocol)s://%(domain)s/grafana/"
      serve_from_sub_path: true
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations: 
      kubernetes.io/ingress.class: nginx
    hosts:
      - homelab.net
    path: /grafana/

```

See the details about grafana config in  [Configure Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#configure-grafana)

You can check ingress resource and grafana.ini data by running the following commands.

* `kubectl -n monitoring describe configmaps prometheus-grafana`
* `kubectl -n monitoring describe ingresses.networking.k8s.io prometheus-grafana`

You can confirm grafana dashboard can be accessible from `http://homelab.net/grafana/`.

* username:   
  `kubectl -n monitoring get secrets prometheus-grafana -o jsonpath={.data.admin-user} | base64 -d`
* password:   
  `kubectl -n monitoring get secrets prometheus-grafana -o jsonpath={.data.admin-password} | base64 -d`

<br>

## Persistent Volume

Define the following part in `custom-values.yaml`. `rook-ceph-block` can be used as a storage class.

<details><summary>storage definition parts</summary>

```
prometheus:
  prometheusSpec:
    storageSpec: 
      volumeClaimTemplate:
        spec:
          storageClassName: rook-ceph-block
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 10Gi

alertmanager:
  alertmanagerSpec:
    storage: 
      volumeClaimTemplate:
        spec:
          storageClassName: rook-ceph-block
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 5Gi
grafana:
  # https://github.com/grafana/helm-charts/blob/c47b39f3bb77d84a3ccc1144e74519b677808b6a/charts/grafana/values.yaml#L296-L323
  persistence:
    type: pvc
    enabled: true
    storageClassName: rook-ceph-block
    accessModes:
      - ReadWriteOnce
    size: 5Gi
    finalizers:
    - kubernetes.io/pvc-protection
```

</details><br>

You can check the dynamic provision works well (PV can be created automatically when requesting PVC).

```
😎 $ kubectl get storageclasses.storage.k8s.io rook-ceph-block 
NAME              PROVISIONER                  RECLAIMPOLICY   VOLUMEBINDINGMODE ALLOWVOLUMEEXPANSION   AGE
rook-ceph-block   rook-ceph.rbd.csi.ceph.com   Delete          Immediate           true                   6d13h
```

```
😎 $ kubectl get pvc,pv
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                                                                                       STORAGECLASS      REASON   AGE
persistentvolume/pvc-0c59a9b1-da24-437d-88a9-5de4ca00d0f6   5Gi        RWO            Delete           Bound    monitoring/alertmanager-prometheus-kube-prometheus-alertmanager-db-alertmanager-prometheus-kube-prometheus-alertmanager-0   rook-ceph-block            17m
persistentvolume/pvc-0eb85794-214c-4022-a7fa-ee9b7c8883b8   10Gi       RWO            Delete           Bound    monitoring/prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0           rook-ceph-block            17h
persistentvolume/pvc-c5f339e8-f09a-41e0-91f0-43f5ae87cf10   5Gi        RWO            Delete           Bound    monitoring/prometheus-grafana                                                                                               rook-ceph-block            8m13s
```

<br>

## Additional Scrape Configs

### Apply a simple app

```
kubectl apply -f api.yaml
```

This app exposes the metrics at the endpoint(`/swagger-stats/metrics`). You can check it as shown below.

```
kubectl -n monitoring port-forward svc/api-service 3000
```
```
😎 $ curl http://localhost:3000/swagger-stats/metrics
# HELP nodejs_process_memory_rss_bytes Node.js process resident memory (RSS) bytes 
# TYPE nodejs_process_memory_rss_bytes gauge
nodejs_process_memory_rss_bytes 56291328

# HELP nodejs_process_memory_heap_total_bytes Node.js process memory heapTotal bytes
# TYPE nodejs_process_memory_heap_total_bytes gauge
nodejs_process_memory_heap_total_bytes 14864384
.
.
```

### Add a target to be scraped

With the prometheus operator, you can declaratively define all the endpoints prometheus should scrape by **creating a ServiceMonitor**. **Prometheus will automatically pickup all targets to scrape from the defined ServiceMonitors**.

ServiceMonitors are a Custom Resource Definition provided by the Prometheus Operator.

* `kubectl get crd`:  
  see all of the CRDs provided by the Prometheus Operator.
* `kubectl get serviceMonitor`:  
  take a look at all of the ServiceMonitors that have been deployed. You can see a separate ServiceMonitor for each of the targets prometheus has already been configured to scrape.

Define `prometheus.additionalServiceMonitors` in `custom-values.yaml`.

```
prometheus:
  additionalServiceMonitors: 
  - name: api-service-monitor
    selector:
      matchLabels:
        app: api
    endpoints:
    - port: web
      interval: 30s
      path: /swagger-stats/metrics
      scheme: http
```

```
kubectl -n monitoring get servicemonitors.monitoring.coreos.com api-service-monitor
```

* `selector.matchLabels`: a selector label to tell prometheus which service to scrape. We will need to match the label of our api-service.
* `spec.endpoints`: has scrape configurations for prometheus.
  * `interval`: equivalent to scrape_interval.
  * `port`: reference the name of the specific port in our service.
  * `path`: specific path that will expose metrics in the container, equivalent to metrics_path config.

You can find `api-service-monitor` under targets and congiguration(scrape_configs) on Prometheus UI.

<br>

## Add recording-rules and alerts

You can take a look at all of the pre-existing rules by running `kubectl get prometheusrules.monitoring.coreos.com` command. To add the new rules, you need to define a new prometheus rules object as `additionalPrometheusRulesMap:` in `custom-values.yaml`.

```
additionalPrometheusRulesMap:
 rule-name:
   groups:
   - name: node-example
     rules:
     - record: node_filesystem_free_percent
       expr: 100* node_filesystem_free_bytes / node_filesystem_size_bytes
     - alert: up (test)
       expr: up == 1
       labels:
         team: infra
         severity: warning
```

You must find `node-example` under rules on Prometheus UI or check the following command as well.

```
😎 $ kubectl -n monitoring get prometheusrules.monitoring.coreos.com kube-prometheus-stack-rule-name -o jsonpath={.spec.groups[0]} | jq
{
  "name": "node-example",
  "rules": [
    {
      "expr": "100* node_filesystem_free_bytes / node_filesystem_size_bytes",
      "record": "node_filesystem_free_percent"
    },
    {
      "alert": "up (test)",
      "expr": "up == 1",
      "labels": {
        "severity": "warning",
        "team": "infra"
      }
    }
  ]
}
```

----------

⚠️

PrometheusRule objects needs to have a specific label (`release: prometheus`) assigned to it so that the Prometheus instance can discover it.

You can cehck `ruleSelector` at the `Prometheus CRD` configuration. `ruleSelector` will have the label that the prometheus instance will look for. 

```
$ kubectl get prometheus -o yaml | grep -A 3 -i ruleSelector
    ruleSelector:
      matchLabels:
        release: prometheus
    scrapeConfigNamespaceSelector: {}
```

-----------

<br>

## Alertmanager config

The prometheus Operator has an AlertmanagerConfig CRD that is used for adding rules to alertmanager (`alertmanager-rule.yaml`).

```
kubectl apply -f alertmanager-rule.yaml
```

**Note: the syntax of the k8s resource: `kind: AlertmanagerConfig` is different from the one of Prometheus config file.**  
Please refer [monitoring.coreos.com_alertmanagerconfigs.yaml](https://github.com/prometheus-operator/prometheus-operator/blob/main/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml) and [AlertmanagerConfig [monitoring.coreos.com/v1alpha1]](https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/alertmanagerconfig-monitoring-coreos-com-v1alpha1.html).

<br>

## Architecture

## _References_

* [Wiki: Installs kube‐prometheus stack](https://github.com/toge510/homelab/wiki/Installs-kube%E2%80%90prometheus-stack)
* [Wiki: Ingress Resource](https://github.com/toge510/homelab/wiki/Ingress-Resource)
* [Ingress-nginx: REWRITE](https://github.com/kubernetes/ingress-nginx/blob/main/docs/examples/rewrite/README.md))
* [Step-by-step guide to setting up Prometheus Alertmanager with Slack, PagerDuty, and Gmail](https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/)
* [[Kubernetes] Prometheus Operator を Helm でイントールする方法](https://fand.jp/technologies/how-to-install-prometheus-operator-with-helm/)

## Memo

The following things are useful if you edit `custom-values.yaml`.

* See the default values with `helm -n monitoring show values prometheus-community/kube-prometheus-stack`
* See the templates files (ex. [kube-prometheus-stack/templates/prometheus
/prometheus.yaml](https://github.com/prometheus-community/helm-charts/blob/3352ef86286a7e8f07266ff3da1a575aa7368c8f/charts/kube-prometheus-stack/templates/prometheus/prometheus.yaml#L320))