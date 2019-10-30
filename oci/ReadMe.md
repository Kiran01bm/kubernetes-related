## What is OCI ?
The Open Container Initiative (OCI) is an open source technical community within which industry participants may easily contribute to building a vendor-neutral, portable and open specification and runtime that deliver on the promise of containers as a source of application portability backed by a certification program.

## What is the mission of the OCI?
The mission of the Open Container Initiative (OCI) is to promote a set of common, minimal, open standards and specifications around container technology. One of their main goals are - Creating a formal specification for container image formats and runtime, which will allow a compliant container to be portable across all major, compliant operating systems and platforms without artificial technical barriers.

## Whats benefits does OCI offer to Container Tech users ?
Users can fully commit to container technologies today without worrying that their current choice of any particular infrastructure, cloud provider, devops tool, etc. will lock them into any technology vendor for the long run. Instead, their choices can be guided by choosing the best tools to build the best applications they can. Equally important, they will benefit by having the industry focus on innovating and competing at the levels that truly make a difference. To use an analogy, why argue about the width of train tracks, when you can worry about laying track and building the best possible engines? Ultimately, we want to make sure that the original promise of containerization—portability, interoperability, and agility—aren’t lost as we move to a world of applications built from multiple containers run using a diverse set of tools across a diverse set of infrastructures.

## What are the drivers for this container specification?
1. A container not bound to higher level constructs such as a particular client or orchestration stack, and
2. A container not tightly associated with any particular commercial vendor or project, and
3. A container portable across a wide variety of operating systems, hardware, CPU architectures, public clouds, etc.

## Facts about OCI:
1. Docker is a founding member of OCI.
2. Docker contributed the Docker V2 Image specification to act as the basis of the OCI image specification.
3. Docker contributed runc, a simple container runtime, as the basis of the OCI runtime specification work.
containerd is responsible for image transfer and storage, container execution and supervision, and low-level functions to support storage and network attachments. Docker donated containerd to the CNCF with the support of the five largest cloud providers: Alibaba Cloud, AWS, Google Cloud Platform, IBM Softlayer and Microsoft Azure with a charter of being a core container runtime for multiple container platforms and orchestration systems. 
4. CRI-O is an open source project in the Kubernetes incubator in the Cloud Native Computing Foundation (CNCF) – it is not an OCI project.
5. OCI is broadly applicable to multi-architecture environments including Linux, Windows and Solaris and covers x86, ARM and IBM zSeries.
