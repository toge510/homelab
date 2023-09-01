# Rook Ceph

[Rook](https://rook.io/docs/rook/latest/Getting-Started/intro/) is  cloud-native storage orchestrator platform to enable highly available, durable Ceph storage in Kubernetes clusters.

## Create Ceph cluster

Follow [DOC: Quickstart](https://rook.io/docs/rook/v1.12/Getting-Started/quickstart/)

* Deploy the Rook Operator
* Create a Ceph Cluster
    ```
    😎$ kubectl -n rook-ceph get po -o wide
    NAME                                                READY   STATUS      RESTARTS   AGE     IP               NODE   
    csi-cephfsplugin-5xnw2                              2/2     Running     0          3m15s   192.168.11.12    worker2
    csi-cephfsplugin-ld572                              2/2     Running     0          3m15s   192.168.11.13    worker3
    csi-cephfsplugin-ppzp4                              2/2     Running     0          3m15s   192.168.11.11    worker 
    csi-cephfsplugin-provisioner-86788ff996-4pmfq       5/5     Running     0          3m15s   10.244.182.3     worker3
    csi-cephfsplugin-provisioner-86788ff996-nvnnf       5/5     Running     0          3m15s   10.244.189.101   worker2
    csi-rbdplugin-78zbk                                 2/2     Running     0          3m15s   192.168.11.12    worker2
    csi-rbdplugin-jfvs4                                 2/2     Running     0          3m15s   192.168.11.11    worker 
    csi-rbdplugin-provisioner-7b5494c7fd-f7n7n          5/5     Running     0          3m15s   10.244.189.103   worker2
    csi-rbdplugin-provisioner-7b5494c7fd-rpkfz          5/5     Running     0          3m15s   10.244.182.55    worker3
    csi-rbdplugin-qh2qk                                 2/2     Running     0          3m15s   192.168.11.13    worker3
    rook-ceph-crashcollector-worker-6457d9755f-ngzpb    1/1     Running     0          2m5s    10.244.171.112   worker 
    rook-ceph-crashcollector-worker2-85f5467c5f-d7p22   1/1     Running     0          115s    10.244.189.112   worker2
    rook-ceph-crashcollector-worker3-679f7946f4-2gvrr   1/1     Running     0          114s    10.244.182.2     worker3
    rook-ceph-mgr-a-6675459b6d-cshkv                    3/3     Running     0          2m25s   10.244.182.27    worker3
    rook-ceph-mgr-b-7cb5f746c5-554x9                    3/3     Running     0          2m23s   10.244.189.114   worker2
    rook-ceph-mon-a-6f44598b77-2bz5l                    2/2     Running     0          3m7s    10.244.182.24    worker3
    rook-ceph-mon-b-7599f4b497-q6hvs                    2/2     Running     0          2m44s   10.244.189.109   worker2
    rook-ceph-mon-c-7858655d86-t2thb                    2/2     Running     0          2m35s   10.244.171.125   worker 
    rook-ceph-operator-d646845-87gct                    1/1     Running     0          3m34s   10.244.182.12    worker3
    rook-ceph-osd-0-5995f4887f-7l4v7                    2/2     Running     0          114s    10.244.171.97    worker 
    rook-ceph-osd-1-59c747758d-dpq75                    2/2     Running     0          115s    10.244.189.90    worker2
    rook-ceph-osd-2-595b9dfd95-fr77c                    2/2     Running     0          114s    10.244.182.29    worker3
    rook-ceph-osd-prepare-worker-wwfkp                  0/1     Completed   0          89s     10.244.171.123   worker 
    rook-ceph-osd-prepare-worker2-fsn6v                 0/1     Completed   0          86s     10.244.189.92    worker2
    rook-ceph-osd-prepare-worker3-s4p9s                 0/1     Completed   0          83s     10.244.182.61    worker3
    ```
* To verify that the cluster is in a healthy state, connect to the Rook toolbox and run the ceph status command.

## Create storageclass `storageclass.storage.k8s.io/rook-ceph-block` and test it

```
kubectl create -f csi/rbd/storageclass.yaml 
kubectl create -f mysql.yaml
kubectl create -f wordpress.yaml
```

```
😎 $ kubectl get pv,pvc
NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
persistentvolumeclaim/mysql-pv-claim   Bound    pvc-c1e762cb-54b2-4157-976e-d340f7b6d3ba   20Gi       RWO            rook-ceph-block   8m32s
persistentvolumeclaim/wp-pv-claim      Bound    pvc-e012ec56-0508-4315-a746-1c2fec6f9376   20Gi       RWO            rook-ceph-block   8m26s
```

## Clean Up 

Folllow [DOC: Cleanup](https://rook.io/docs/rook/latest/Storage-Configuration/ceph-teardown/)

* Delete the Block and File artifacts
* Delete the CephCluster CRD  
    If the cleanupPolicy was applied, then wait for the rook-ceph-cleanup jobs to be completed on all the nodes. These jobs will perform the following operations:
    * Delete the namespace directory under dataDirHostPath, for example /var/lib/rook/rook-ceph, on all the nodes
    * Wipe the data on the drives on all the nodes where OSDs were running in this cluster  
    */var/lib/rook/rook-ceph: Path on each host in the cluster where configuration is cached by the ceph mons and osds
* Delete namespace
    ```
    kubectl delete ns rook-ceph
    NAMESPACE=rook-ceph
    kubectl proxy &
    kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' > temp.json
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
    rm temp.json
    kubectl get ns rook-ceph 
    ```
    * *Finalizers are conditions that must be satisfied before a resource can be deleted
    * [Namespace "stuck" as Terminating, How I removed it](https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-i-removed-it)