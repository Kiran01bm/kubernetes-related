# General Notes

1. Buildah allows for finer control of creating image layers. Committing many changes to a single layer is desirable.
2. Buildah run is for running specific commands in order to help build a container image, for example:
	buildah run dnf -y install nginx.
3. Like Podman - Buildah doesn’t require a daemon to run on a host in order to build a container image.
4. CRI-O and runC solve the runtime problem and CRI-O, runC and Buildah solve the build problem.
5. For Demo run script in - [Buildah Intro](https://github.com/containers/Demos/blob/master/building/buildah_intro/buildah_intro.sh)




# Dedicated build nodes, Think again ??
With something like Kubernetes you really don’t want to waste resources with dedicated nodes which might sit idle when not doing builds. It’s much better to schedule builds in the cluster, just like any other process. There are several reasons for this.

1. In a continuous integration, multi-tenant environment there can be multiple builds going on at any time. So if your cluster is a PaaS for developers you want to be able to schedule builds whenever the developer needs them as quickly as possible. Having the ability to schedule across the cluster is very efficient.
2. When new base images become available in a continuous deployment environment, you will want to take advantage of them as soon as possible. This may cause a spike of build activity that you want to spread across the cluster rather than overloading a single machine.
3. Related to the second point, when security events like a CVE occurs, many images will need to be rebuilt to ensure the vulnerability is addressed. Again this is going to cause spikes and will require many simultaneous build resources.
