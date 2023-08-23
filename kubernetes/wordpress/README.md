# Wordpress 

WordPress is the world's most popular blogging and content management platform. Powerful yet simple, everyone from students to global corporations use it to build beautiful, functional websites.

## Deploy Wordpress with Helm 

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

```
helm repo list
```

```
helm install my-wordpress bitnami/wordpress -f custom-values.yaml --create-namespace --namespace app
```

## Customize ingress

Set hostname no-specified host (`*`) not to set `wordpress.local` which is the default value as hostname.

```
kubectl -n app get ingress my-wordpress -o yaml > custom-ingress.yaml
```

Delete `host: wordpress.local` in `custom-ingress.yaml` and apply it.

```
kubectl apply -f custom-ingress.yaml
```

Go to `192.168.11.245/wordpress`

## __References__

* [Artifact HUB: Wordpress](https://artifacthub.io/packages/helm/bitnami/wordpress)
* [WordPress packaged by Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/wordpress)