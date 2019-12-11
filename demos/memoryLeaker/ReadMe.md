# Simulate CPU Load

**Ref from** [here](https://github.com/derekwaynecarr/java-oom/blob/master/src/main/java/com/example/oom/Simulator.java)

## Memory Requests/Limits - Scenario
1. If you set a Limit but don’t set a Request - Kubernetes will default the Request to the Limit. When "workloads memory consumption" = "memory limit" then kubelet kills the container.

2. If you set a Request with no Limit - In this case kubernetes is able to accurately schedule your pod, and the workload can consume as much as memory it needs and you risk compromising other workloads on the same node. 

3. If you dont set either a Request or a Limit (worst case scenario): Same risk as in #2.

## Deployments
1. kubeDeploymentUnbounded.yaml - No Requests or Limits
2. kubeDeployment.yaml - Both Requests and Limits
3. docker-compose.yml - Helps with testing on Local Docker Daemon

