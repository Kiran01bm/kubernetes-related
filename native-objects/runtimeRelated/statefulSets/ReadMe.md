# General Notes

StatefulSet is the workload API object used to manage stateful applications. Like a Deployment , a StatefulSet manages Pods that are based on an identical container spec but thats where the similarity sort of ends.

## 2 Unique Aspects of Statefulsets
1. StatefulSet Pods have a unique identity that is comprised of an ordinal, a stable network identity (via Headless Service), and stable storage (**PV associated with a Staeful pods PVC is never deleted even with Cascading delete**). The identity sticks to the Pod, regardless of which node it’s (re)scheduled on.
2. Ordered - Deploy, Scale-In, Scale-Out, Updates, UnDeploy - This is the default behavior but can be changed via **Pod Management Policy**

## When Statefulsets ?
StatefulSets are valuable for applications that require one or more of the following.

1. Stable, unique network identifiers - Achieved via Ordinal Number and Headless Service for unique Network Identity.
2. Stable, persistent storage - Volume claim name of a stateful pod will be **$volumeClaimTemplates/Name-$podName**. Delete of a stateful pod will not delete the Persistent Storage associated with the pods PVC.
3. Ordered, graceful deployment, scaling and undeploy - Deployment and Scaling Guarantees ex: Delete of Statefulset does not guarantee Gracefulness, It should instead be a scale-down to 0. 
4. Ordered, automated rolling updates. 

![Stable Network Indentity](images/stableNetworkIdentity.png?raw=true "Stable Network Indentity")

## Updates
Driven by the Statefulsets - updateStrategy. It support 2 values:
1. RollingUpdate - Use **Partitioning - for staged updates via Rolling updates partition field**. Staged could be Canary, Rolling, You could also do e.g. a linear, geometric, or exponential roll out for statefulsets which has higher replica numbers.
```
Ex: kubectl patch statefulset db -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'

Here all the stateful pods having ordinals >=2 are updated when mutations to Statefulsets .spec.template are detected
```
2. OnDelete - The StatefulSet controller will **not automatically update** Pods when mutations to Statefulsets .spec.template are detected.
Use this for Production scenarios.

## Delete
1. Cascading = False - Deletes the StatefulSet, and **to not delete any of its Pods.**
2. Cascading = True - Deletes the Statefulset **and** the Pods. Like scaling down - The Pods are terminated one at a time, with respect to the reverse order of their ordinal indices. 
**Note:** Cascading delete will not delete the headless service associated with the statefulset. Persistent volumes associated with Stateful set pods are never deleted.

## Pod Management Policy
1. OrderedReady pod management is the default for StatefulSets. It tells the StatefulSet controller to respect the ordering guarantees
2. Parallel pod management tells the StatefulSet controller to launch or terminate all Pods in parallel, and not to wait for Pods to become Running and Ready or completely terminated prior to launching or terminating another Pod.
