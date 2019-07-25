# General Notes

StatefulSet is the workload API object used to manage stateful applications. Like a Deployment , a StatefulSet manages Pods that are based on an identical container spec but thats where the similarity sort of ends.

## 2 Unique Aspects of Statefulsets
1. StatefulSet Pods have a unique identity that is comprised of an ordinal, a stable network identity, and stable storage. The identity sticks to the Pod, regardless of which node it’s (re)scheduled on.
2. Ordered - Deploy, Scale-In, Scale-Out, Updates, UnDeploy.

## When Statefulsets ?
StatefulSets are valuable for applications that require one or more of the following.

1. Stable, unique network identifiers - Achieved via Ordinal Number and Headless Service for unique Network Identity.
2. Stable, persistent storage - Where state is stored. A Pod's volumeClaimTemplates will provide stable storage using PersistentVolumes provisioned by a PersistentVolume Provisioner.
3. Ordered, graceful deployment, scaling and undeploy - Deployment and Scaling Guarantees ex: Delete of Statefulset does not guarantee Gracefulness, It should instead be a scale-down to 0. 
4. Ordered, automated rolling updates. 

![Stable Network Indentity](images/stableNetworkIdentity.png?raw=true "Stable Network Indentity")


