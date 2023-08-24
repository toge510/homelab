<div align="center">
<img src="https://github.com/komodorio/helm-dashboard/raw/main/pkg/dashboard/static/logo-header.svg#gh-light-mode-only">
</div>

Helm Dashboard is an open-source project which offers a UI-driven way to view the installed Helm charts, see their revision history and corresponding k8s resources.

## Deploy with helm


```
helm install helm-dashboard komodorio/helm-dashboard --version 0.1.10 --create-namespace --namespace helm -f custom-values.yaml
```

Goto `192.168.11.245/helm`

## _References_

* [helm dashboard](https://github.com/komodorio/helm-charts/tree/master/charts/helm-dashboard)