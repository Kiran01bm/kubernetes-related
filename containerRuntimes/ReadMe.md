# General Notes

## Conatiner runtime options
runc, rkt, frakti, cri-containerd and more. 

## CRI - Container Runtime Interface
Most of the Conatiner Runtimes are based on the **OCI standard** which defines how the runtimes start and run your containers, but they lack a standard way of interfacing with an orchestrator. This makes things complicated for tools like kubernetes, which run on top of a container runtime to provide you with orchestration, high availability, and management. Kubernetes therefore introduced a standard API to be able to talk to and manage a container runtime. This API is called the Container Runtime Interface (CRI).

## CRI-O 
Existing container runtimes like Docker use a “shim” to interface between Kubernetes and the runtime, but there is another way, using an interface that was designed to work with CRI natively. And that is where CRI-O comes into the picture. CRI-O implements the CRI Interface for OCI compliant runtimes and uses the lightweight **runc** runtime to actually run the containers

CRI-O has graduated from Kubernetes incubator project to become an official part of the Kubernetes family of tools.

## Why CRI-O ??
1. Aligned with Kubernetes: As an official Kubernetes project, CRI-O releases in lock step with Kubernetes, with similar version numbers. ie. CRI-O 1.11.x works with Kubernetes 1.11.x. 
2. Lightweight: CRI-O is made of lots of small components, each with specific roles, working together with other pieces to give you a fully functional container experience. In comparison, the Docker Engine is a heavyweight daemon which is communicated to using the docker CLI tool in a client/server fashion.
3. More Securable: Every container run using the Docker CLI is a ‘child’ of that large Docker Daemon. This complicates or outright prevents the use of tooling like cgroups & security constraints to provide an extra layer of protection to your containers. As CRI-O containers are children of the process that spawned it (not the daemon) they’re fully compatible with these tools without complication.

## Podman
Based on containers/libpod project Podman is a tool for managing Pods, Containers, and Container Images. The CLI for Podman is based on the Docker CLI, although Podman does not require a runtime daemon to be running in order to function. It is to CRI-O what the Docker CLI tool is to the Docker Engine daemon. It even has a very similar syntax.

Refer [Podman Usage Transfer](https://github.com/containers/libpod/blob/master/transfer.md) for a) Podman commands for equivalent Docker CLI commands b) Docker CLI commands that are not in Podman c) Podman commands that are not in Docker CLI.

Podman also benefits from CRI-Os more lightweight architecture. Because every Podman container is a direct child of the podman command that created it, it’s trivial to use podman as part of systemd services. This can be combined with systemd features like socket activation to do really cool things like starting your container only when users try to access it!

## Miscellaneous
1. For the basic use case of running containers, both docker and podman can co-exist on a system safely. 
2. The Docker Engine doesn’t co-exist with CRI-O quite so well in the Kubernetes scenario.
