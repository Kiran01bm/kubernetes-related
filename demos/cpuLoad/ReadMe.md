# Simulate CPU Load

**Ref from** [here](https://github.com/pradykaushik/cpu-load-generator)

## CPU Requests/Limits - Scenario
1. If you set a Limit but don’t set a Request - Kubernetes will default the Request to the Limit. This can be fine if you have very good knowledge of how much cpu time your workload requires. 

2. If you set a Request with no Limit - In this case kubernetes is able to accurately schedule your pod, and the kernel will make sure it gets at least the number of shares asked for, but your process will not be prevented from using more than the amount of cpu requested, which will be stolen from other process’s cpu shares when available. 

3. If you dont set either a Request or a Limit (worst case scenario): The scheduler has no idea what the container needs, and the process’s use of cpu shares is unbounded, which may affect the node adversely. And that’s a good segue into the last thing I want to talk about: ensuring default limits in a namespace.

## Deployments
1. kubeDeploymentUnbounded.yaml - No Requests or Limits
2. kubeDeployment.yaml - Both Requests and Limits

## Sample Output
```
ζ docker stats $(docker ps | grep cpuloadgen | grep -v -i POD | awk '{print $1}')
CONTAINER ID        NAME                                                                                                                      CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
4a82e0fb7d36        k8s_cpuloadgen_cpuloadgen-deployment-67864c4998-ptjpn_default_a4873252-5574-4f50-945f-7dc743fc863b_0                      15.32%              19.35MiB / 128MiB     15.12%              1.4kB / 0B          0B / 0B             16
68cde26cd4da        k8s_cpuloadgen-unbounded_cpuloadgen-unbounded-deployment-8989d84f9-6dsjc_default_8a9c5518-7f39-4fbf-baab-ad86f431f163_0   129.65%             18.62MiB / 1.894GiB   0.96%               1.4kB / 0B          0B / 0B             16
```
