# General Notes

In Podman, the status of the pod and its containers can be exclusive to each other meaning that containers within pods can be restarted, stopped, and started without impacting the status of the pod. 

Podman’s local repository is in /var/lib/containers and for users with rootless podman - ~/.local/share/containers

Podman can use different user namespaces on the same image because of automatic chowning built into containers/storage project. Podman uses containers/storage, and the first time Podman uses a container image in a new user namespace, container/storage "chowns" (i.e., changes ownership for) all files in the image to the UIDs mapped in the user namespace and creates a new image. Think of this as the fedora:0:100000:5000 image. When Podman runs another container on the image with the same UID mappings, it uses the "pre-chowned" image. When I run the second container on 0:200000:5000, containers/storage creates a second image fedora:0:200000:5000..

Every Podman pod includes an “infra” container.   This container does nothing, but go to sleep. Its purpose is to hold the namespaces associated with the pod and allow podman to connect other containers to the pod. This allows you to start and stop containers within the POD and the pod will stay running, where as if the primary container controlled the pod, this would not be possible. The default infra container is based on the k8s.gcr.io/pause image,  Unless you explicitly say otherwise, all pods will have container based on the default image.

Most of the attributes that make up the Pod are actually assigned to the “infra” container.  Port bindings, cgroup-parent values, and kernel namespaces are all assigned to the “infra” container. This is critical to understand, because once the pod is created these attributes are assigned to the “infra” container and cannot be changed. For example, if you create a pod and then later decide you want to add a container that binds new ports, Podman will not be able to do this.  You would need to recreate the pod with the additional port bindings before adding the new container.

In the above diagram, notice the box above each container, conmon, this is the container monitor.  It is a small C Program that’s job is to watch the primary process of the container, and if the container dies, save the exit code.  It also holds open the tty of the container, so that it can be attached to later. This is what allows podman to run in detached mode (backgrounded), so podman can exit but conmon continues to run.  Each container has its own instance of conmon.


### List Podman Pods
```podman pod list or podman pod ps or podman pod ls```
### List Containers in a Podman Pod
```podman ps -a --pod```
### Add Container to a pod
```podman run -dt --pod PODNAME docker.io/library/alpine:latest top```
### Stop a Container in a Pod
```podman stop CONTAINERNAME```
### Start a Container in a Pod
```podman start CONTAINERNAME```
### Stop Pod - This stops all the containers in the Pod
```podman pod stop PODNAME```
### Start Pod - This starts all the containers in the Pod
```podman pod start PODNAME```
### Restart Pod - This restarts all the containers in the Pod
```podman pod restart PODNAME```
### Pull an image from Docker Image store into Podmans Image store
```podman pull docker-daemon:myimage:latest```
### Push image
```podman push quay.io/kiran01bm/myimage:lates```t
### Run Image
```podman run -it quay.io/kiran01bm/myimage:latest  bash```
```podman run -dt quay.io/kiran01bm/myimage:latest```
### Generate Kubernetes Object definition for a running container
```podman generate kube CONTAINERNAME```
### Build - Podman’s build command contains a subset of the Buildah functionality. It uses the same code as **Buildah** for building.
```podman build```
### Inspect User Info - user is UID in container and husers is the UID on the host
```podman top --latest user huser```
