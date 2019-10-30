# General Notes

## Certified Hosted Offerings (popular ones)
1. GKE
2. EKS
3. AKS


## Certified Distribution (popular ones)
1. OpenShift
2. Docker EE/CE
3. PKS
4. Rancher Kubernetes


## Offerings - OnPrem (popular ones)
1. Anthos - GKE on Prem, Customers can deploy this on any compatible hardware and Google will manage the platform
2. Kubernetes - Self-managed


## Cloud - Self Managed
1. Kubernetes

## CNCF Projects around CxI
CRI, CNI, CSI

### What is CRI ?
[Refer here](https://github.com/Kiran01bm/kubernetes-related/tree/master/cri)

#### What is CRI-O ?
CRI-O is an implementation of the Kubernetes CRI (Container Runtime Interface) to enable using OCI (Open Container Initiative) compatible runtimes. It is a lightweight alternative to using Docker as the runtime for kubernetes. It allows Kubernetes to use any OCI-compliant runtime as the container runtime for running pods. Today it supports runc and Kata Containers as the container runtimes but any OCI-conformant runtime can be plugged in principle. CRI-O is a Kubernetes incubator in the Cloud Native Computing Foundation (CNCF)

CRI-O supports OCI container images and can pull from any container registry. It is a lightweight alternative to using Docker, Moby or rkt as the runtime for Kubernetes.

### What is CNI ?
CNI (Container Network Interface), a Cloud Native Computing Foundation project, consists of a specification and libraries for writing plugins to configure network interfaces in Linux containers, along with a number of supported plugins. CNI concerns itself only with network connectivity of containers and removing allocated resources when the container is deleted. Because of this focus, CNI has a wide range of support and the specification is simple to implement. 
**Note:** Various container runtimes (runc, rkt), orchestrators (OpenShift, Kubernetes, Rancher, ECS etc) and network plugin providers (Calico, VMware NSX, Weave, Multus etc) use CNI.

### What is CSI ?
[Refer here](https://github.com/Kiran01bm/kubernetes-related/tree/master/csi)
**Note:** Various orchestrators (OpenShift, Kubernetes, Rancher, Cloudfoundry, Mesos) and storage plugin providers () use CSI.


