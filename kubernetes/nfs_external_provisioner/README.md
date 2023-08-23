# NFS external provisioner

Dynamic volume provisioning allows storage volumes to be created on-demand. The dynamic provisioning feature eliminates the need for cluster administrators to pre-provision storage. Instead, it automatically provisions storage (`PV`) when it is requested by users (`PVC`). NFS external provisioner can achieve dynamic volume provisioning.

To enable dynamic provisioning, a cluster administrator needs to pre-create one or more StorageClass objects for users. StorageClass objects define which provisioner should be used and what parameters should be passed to that provisioner when dynamic provisioning is invoked. 

Here you can use NFS external provisioner.

## NFS external server

Please take a look at `kubernetes/nfs/README.md`.

* server ip address: `192.168.11.20`
* exported directory: `/share`

## Set-up NFS external provisoner

Deploy NFS Subdir External Provisioner to your cluster with Helm.

```
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f custom-values.yaml --create-namespace --namespace external-provisioner
```

## Verification

Deploy the test resources:

```
kubectl create -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-claim.yaml -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-pod.yaml
```

The manifest files of PVC and Pod are below.

<table>
<tr>
<td>

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
spec:
  storageClassName: nfs-client
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
```

</td>
<td>

```
kind: Pod
apiVersion: v1
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: busybox:stable
    command:
      - "/bin/sh"
    args:
      - "-c"
      - "touch /mnt/SUCCESS && exit 0 || exit 1"
    volumeMounts:
      - name: nfs-pvc
        mountPath: "/mnt"
  restartPolicy: "Never"
  volumes:
    - name: nfs-pvc
      persistentVolumeClaim:
        claimName: test-claim
```

</td>
</tr>
</table>

PVC's status is "Bound" and pv can be created automatically (dynamic provisoning works!).

```
$ kubectl get pvc
NAME         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
test-claim   Bound    pvc-3ce23c82-920f-4eba-954f-66973ed977b0   1Mi        RWX            nfs-client     2m3s
```
```
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
pvc-3ce23c82-920f-4eba-954f-66973ed977b0   1Mi        RWX            Delete           Bound    default/test-claim   nfs-client              3m20s
```

`SUCCESS` file is inside the PVC's directory on NFS Server.

```
$ ls /share/default-test-claim-pvc-3ce23c82-920f-4eba-954f-66973ed977b0/
SUCCESS
```

Delete the test resources:

```
$ kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-claim.yaml -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-pod.yaml
```

## __References__

* [Wiki: NFS subdir external provisioner](https://github.com/toge510/homelab/wiki/NFS-subdir-external-provisioner)
* [Kubernetes NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)