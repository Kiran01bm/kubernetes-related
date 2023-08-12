## Background

1. By default, containers run with unbounded compute resources on a Kubernetes cluster. Using Kubernetes **Resource Quotas**, administrators (also termed `cluster operators`) can restrict **consumption and creation** of cluster resources (such as CPU time, memory, and persistent storage) within a specified namespace.
2. Within a namespace, a Pod can consume as much CPU and memory as is allowed by the ResourceQuotas that apply to that namespace. As a cluster operator, or as a `namespace-level` administrator, you might also be concerned about making sure that a single object cannot monopolize all available resources within a namespace.


## Limit Range

A LimitRange is a policy to constrain the resource allocations (limits and requests) that you can specify for each applicable object kind (such as Pod or PersistentVolumeClaim) in a namespace.

A LimitRange provides constraints that can:

1. Enforce minimum and maximum compute resources usage per Pod or Container in a namespace.
2. Enforce minimum and maximum storage request per PersistentVolumeClaim in a namespace.
3. Enforce a ratio between request and limit for a resource in a namespace.
4. Set default request/limit for compute resources in a namespace and automatically inject them to Containers at runtime.
5. A LimitRange is enforced in a particular namespace when there is a LimitRange object in that namespace.
6. The name of a LimitRange object must be a valid DNS subdomain name.

### Limit Range workflow and Gotchas
1. The administrator creates a LimitRange in a namespace.
2. Users create (or try to create) objects in that namespace, such as Pods or PersistentVolumeClaims.
3. **First, the LimitRange admission controller** applies default request and limit values for all Pods (and their containers) that do not set compute resource requirements.
4. **Second, the LimitRange tracks usage** to ensure it does not exceed resource minimum, maximum and ratio defined in any LimitRange present in the namespace.
5. If you attempt to create or update an object (Pod or PersistentVolumeClaim) that violates a LimitRange constraint, your request to the API server will fail with an HTTP status code 403 Forbidden and a message explaining the constraint that has been violated.
6. If you add a LimitRange in a namespace that applies to compute-related resources such as cpu and memory, you must specify requests or limits for those values. Otherwise, the system may reject Pod creation.
7. LimitRange validations occur only at **Pod admission stage**, not on running Pods. If you add or modify a LimitRange, the Pods that already exist in that namespace continue unchanged.
8. If two or more LimitRange objects exist in the namespace, it is **not deterministic** which default value will be applied.
