# DownWardAPI Volume

## Motivation
It is sometimes useful for a Container to have information about itself, without being overly coupled to Kubernetes. The Downward API allows containers to consume information about themselves or the cluster without using the Kubernetes client or API server.

## Options
There are two ways to expose Pod and Container fields to a running Container:

1. Environment variables
2. DownwardAPIVolumeFiles

Together, these two ways of exposing Pod and Container fields are called the Downward API.

```
kubectl exec -it kubernetes-downwardapi-volume-example -- sh

/# cat /etc/podinfo/labels
/# cat /etc/podinfo/annotations

/# ls -laR /etc/podinfo
drwxr-xr-x  ... Feb 6 21:47 ..2982_06_02_21_47_53.299460680
lrwxrwxrwx  ... Feb 6 21:47 ..data -> ..2982_06_02_21_47_53.299460680
lrwxrwxrwx  ... Feb 6 21:47 annotations -> ..data/annotations
lrwxrwxrwx  ... Feb 6 21:47 labels -> ..data/labels

/# ls -laR /etc/..2982_06_02_21_47_53.299460680:
total 8
-rw-r--r--  ... Feb  6 21:47 annotations
-rw-r--r--  ... Feb  6 21:47 labels

```

## Note
A container using Downward API as a subPath volume mount will not receive Downward API updates.

**Because:** Using symbolic links enables dynamic atomic refresh of the metadata; updates are written to a new temporary directory, and the ..data symlink is updated atomically using rename.
