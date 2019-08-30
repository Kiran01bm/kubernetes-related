```
~/Documents/GIT ⌚ 15:39:47
$ sysctl -a | grep -E --color 'machdep.cpu.features|VMX'
machdep.cpu.features: FPU VME DE PSE TSC MSR PAE MCE CX8 APIC SEP MTRR PGE MCA CMOV PAT PSE36 CLFSH DS ACPI MMX FXSR SSE SSE2 SS HTT TM PBE SSE3 PCLMULQDQ DTES64 MON DSCPL VMX EST TM2 SSSE3 FMA CX16 TPR PDCM SSE4.1 SSE4.2 x2APIC MOVBE POPCNT AES PCID XSAVE OSXSAVE SEGLIM64 TSCTMR AVX1.0 RDRAND F16C

~/Documents/Labs/kubefed ⌚ 15:45:30
$ minikube start -p cluster1 --kubernetes-version v1.13.4
😄  [cluster1] minikube v1.3.1 on Darwin 10.13.6
💿  Downloading VM boot image ...
minikube-v1.3.0.iso.sha256: 65 B / 65 B [--------------------] 100.00% ? p/s 0s
minikube-v1.3.0.iso: 131.07 MiB / 131.07 MiB [-------] 100.00% 6.50 MiB p/s 20s
🔥  Creating virtualbox VM (CPUs=2, Memory=2000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.13.4 on Docker 18.09.8 ...
💾  Downloading kubeadm v1.13.4
💾  Downloading kubelet v1.13.4
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for: apiserver proxy etcd scheduler controller dns
🏄  Done! kubectl is now configured to use "cluster1"

~/Documents/Labs/kubefed ⌚ 15:49:58
$ minikube start -p cluster2 --kubernetes-version v1.13.4
😄  [cluster2] minikube v1.3.1 on Darwin 10.13.6
🔥  Creating virtualbox VM (CPUs=2, Memory=2000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.13.4 on Docker 18.09.8 ...
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for: apiserver proxy etcd scheduler controller dns
🏄  Done! kubectl is now configured to use "cluster2"

~/Documents/Labs/kubefed ⌚ 16:13:19
$ kubectl config use-context cluster1
Switched to context "cluster1".

~/Documents/Labs/kubefed ⌚ 16:23:38
$ cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
serviceaccount/tiller created
clusterrolebinding.rbac.authorization.k8s.io/tiller created

~/Documents/Labs/kubefed ⌚ 16:23:44
$ helm init --service-account tiller
$HELM_HOME has been configured at /Users/kiran/.helm.

Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.

Please note: by default, Tiller is deployed with an insecure 'allow unauthenticated users' policy.
To prevent this, run `helm init` with the --tiller-tls-verify flag.
For more information on securing your installation see: https://docs.helm.sh/using_helm/#securing-your-helm-installation
Happy Helming!

~/Documents/Labs/kubefed ⌚ 16:23:52
$ helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
"kubefed-charts" has been added to your repositories

~/Documents/Labs/kubefed ⌚ 16:24:05
$ helm repo list
NAME          	URL
stable        	https://kubernetes-charts.storage.googleapis.com
local         	http://127.0.0.1:8879/charts
kubefed-charts	https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts

~/Documents/Labs/kubefed ⌚ 16:24:11
$ helm search kubefed
NAME                        	CHART VERSION	APP VERSION	DESCRIPTION
kubefed-charts/kubefed      	0.1.0-rc6    	           	KubeFed helm chart
kubefed-charts/federation-v2	0.0.10       	           	Kubernetes Federation V2 helm chart

~/Documents/Labs/kubefed ⌚ 16:24:22

~/Documents/Labs/kubefed ⌚ 16:26:09
$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "kubefed-charts" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈ Happy Helming!⎈

~/Documents/Labs/kubefed ⌚ 16:43:31
$ mv ~/Downloads/kubefedctl-0.1.0-rc6-darwin-amd64.tgz .

~/Documents/Labs/kubefed ⌚ 16:43:44
$ tar -xvzf kubefedctl-0.1.0-rc6-darwin-amd64.tgz
x kubefedctl

~/Documents/Labs/kubefed ⌚ 16:43:58
$ ls -lart
total 133544
-rwxr-xr-x@  1 kiran  staff  42040312 17 Aug 13:55 kubefedctl
drwxr-xr-x  12 kiran  staff       384 30 Aug 15:45 ..
-rw-r--r--@  1 kiran  staff   7987517 30 Aug 16:39 kubefed-0.1.0-rc5.tar.gz
-rw-r--r--@  1 kiran  staff  16885956 30 Aug 16:43 kubefedctl-0.1.0-rc6-darwin-amd64.tgz
drwxr-xr-x   5 kiran  staff       160 30 Aug 16:43 .

~/Documents/Labs/kubefed ⌚ 16:44:00
~/Documents/Labs/kubefed ⌚ 17:03:57
$ helm install kubefed-charts/kubefed  --name kubefed --version=0.1.0-rc6 --namespace kube-federation-system
NAME:   kubefed
LAST DEPLOYED: Fri Aug 30 17:04:36 2019
NAMESPACE: kube-federation-system
STATUS: DEPLOYED

RESOURCES:
==> v1/ClusterRole
NAME                                AGE
kubefed-role                        1s
system:kubefed:admission-requester  1s

==> v1/ClusterRoleBinding
NAME                                      AGE
kubefed-admission-webhook:anonymous-auth  1s
kubefed-admission-webhook:auth-delegator  1s
kubefed-rolebinding                       1s

==> v1/Deployment
NAME                        READY  UP-TO-DATE  AVAILABLE  AGE
kubefed-admission-webhook   0/1    1           0          1s
kubefed-controller-manager  0/2    2           0          1s

==> v1/Pod(related)
NAME                                         READY  STATUS             RESTARTS  AGE
kubefed-admission-webhook-69dcf88f7-mvhk4    0/1    ContainerCreating  0         1s
kubefed-controller-manager-566d699f55-rmklt  0/1    ContainerCreating  0         1s
kubefed-controller-manager-566d699f55-x4wpv  0/1    ContainerCreating  0         1s

==> v1/Role
NAME                            AGE
kubefed-admission-webhook-role  1s
kubefed-config-role             1s

==> v1/RoleBinding
NAME                                           AGE
kubefed-admission-webhook-rolebinding          1s
kubefed-admission-webhook:apiextension-viewer  1s
kubefed-config-rolebinding                     1s

==> v1/Secret
NAME                                    TYPE               DATA  AGE
kubefed-admission-webhook-serving-cert  kubernetes.io/tls  2     1s

==> v1/Service
NAME                       TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)  AGE
kubefed-admission-webhook  ClusterIP  10.97.118.105  <none>       443/TCP  1s

==> v1/ServiceAccount
NAME                       SECRETS  AGE
kubefed-admission-webhook  1        1s
kubefed-controller         1        1s

==> v1beta1/FederatedTypeConfig
NAME                                    AGE
clusterroles.rbac.authorization.k8s.io  1s
configmaps                              1s
deployments.apps                        1s
ingresses.extensions                    1s
jobs.batch                              1s
namespaces                              1s
replicasets.apps                        1s
secrets                                 1s
serviceaccounts                         1s
services                                1s

==> v1beta1/KubeFedConfig
NAME     AGE
kubefed  1s

==> v1beta1/MutatingWebhookConfiguration
NAME                      AGE
mutation.core.kubefed.io  1s

==> v1beta1/ValidatingWebhookConfiguration
NAME                         AGE
validations.core.kubefed.io  1s



~/Documents/Labs/kubefed ⌚ 17:04:38
$ kubectl get pods -n kube-federation-system
NAME                                          READY   STATUS              RESTARTS   AGE
kubefed-admission-webhook-69dcf88f7-mvhk4     0/1     ContainerCreating   0          34s
kubefed-controller-manager-566d699f55-rmklt   0/1     ContainerCreating   0          34s
kubefed-controller-manager-566d699f55-x4wpv   0/1     ContainerCreating   0          34s

~/Documents/Labs/kubefed ⌚ 17:05:11
$ kubectl get pods -n kube-federation-system
NAME                                          READY   STATUS    RESTARTS   AGE
kubefed-admission-webhook-69dcf88f7-mvhk4     1/1     Running   0          2m36s
kubefed-controller-manager-566d699f55-rmklt   1/1     Running   0          2m36s
kubefed-controller-manager-566d699f55-x4wpv   1/1     Running   0          2m36s

~/Documents/Labs/kubefed ⌚ 17:07:13
~/Documents/Labs/kubefed ⌚ 17:07:36
$ ./kubefedctl join cluster1 --cluster-context cluster1 \
    --host-cluster-context cluster1 --v=2
./kubefedctl join cluster2 --cluster-context cluster2 \
    --host-cluster-context cluster1 --v=2
I0830 17:08:19.757691   36154 join.go:159] Args and flags: name cluster1, host: cluster1, host-system-namespace: kube-federation-system, kubeconfig: , cluster-context: cluster1, secret-name: , dry-run: false
I0830 17:08:19.895496   36154 join.go:238] Performing preflight checks.
I0830 17:08:19.898182   36154 join.go:244] Creating kube-federation-system namespace in joining cluster
I0830 17:08:19.901154   36154 join.go:377] Already existing kube-federation-system namespace
I0830 17:08:19.901176   36154 join.go:252] Created kube-federation-system namespace in joining cluster
I0830 17:08:19.901189   36154 join.go:398] Creating service account in joining cluster: cluster1
I0830 17:08:19.909516   36154 join.go:408] Created service account: cluster1-cluster1 in joining cluster: cluster1
I0830 17:08:19.909536   36154 join.go:436] Creating cluster role and binding for service account: cluster1-cluster1 in joining cluster: cluster1
I0830 17:08:19.933692   36154 join.go:445] Created cluster role and binding for service account: cluster1-cluster1 in joining cluster: cluster1
I0830 17:08:19.933748   36154 join.go:804] Creating cluster credentials secret in host cluster
I0830 17:08:19.941661   36154 join.go:830] Using secret named: cluster1-cluster1-token-wbml9
I0830 17:08:19.955985   36154 join.go:873] Created secret in host cluster named: cluster1-s5zxp
I0830 17:08:19.982002   36154 join.go:280] Created federated cluster resource
I0830 17:08:20.036357   36155 join.go:159] Args and flags: name cluster2, host: cluster1, host-system-namespace: kube-federation-system, kubeconfig: , cluster-context: cluster2, secret-name: , dry-run: false
I0830 17:08:20.179543   36155 join.go:238] Performing preflight checks.
I0830 17:08:20.189954   36155 join.go:244] Creating kube-federation-system namespace in joining cluster
I0830 17:08:20.204048   36155 join.go:252] Created kube-federation-system namespace in joining cluster
I0830 17:08:20.204090   36155 join.go:398] Creating service account in joining cluster: cluster2
I0830 17:08:20.223341   36155 join.go:408] Created service account: cluster2-cluster1 in joining cluster: cluster2
I0830 17:08:20.223372   36155 join.go:436] Creating cluster role and binding for service account: cluster2-cluster1 in joining cluster: cluster2
I0830 17:08:20.265156   36155 join.go:445] Created cluster role and binding for service account: cluster2-cluster1 in joining cluster: cluster2
I0830 17:08:20.265206   36155 join.go:804] Creating cluster credentials secret in host cluster
I0830 17:08:20.274285   36155 join.go:830] Using secret named: cluster2-cluster1-token-rjzlj
I0830 17:08:20.280230   36155 join.go:873] Created secret in host cluster named: cluster2-7kbkq
I0830 17:08:20.299872   36155 join.go:280] Created federated cluster resource

~/Documents/Labs/kubefed ⌚ 17:08:20
$ kubectl -n kube-federation-system get kubefedclusters
NAME       READY   AGE
cluster1   True    15s
cluster2   True    14s
~/Documents/Labs/kubefed ⌚ 17:19:23
$ ./isAPIGroupInCluster.sh
----- cluster1 -----
NAME                       SHORTNAMES   APIGROUP      NAMESPACED   KIND
horizontalpodautoscalers   hpa          autoscaling   true         HorizontalPodAutoscaler
----- cluster2 -----
NAME                       SHORTNAMES   APIGROUP      NAMESPACED   KIND
horizontalpodautoscalers   hpa          autoscaling   true         HorizontalPodAutoscaler
~/Documents/Labs/kubefed ⌚ 17:35:41
$ cat isAPIGroupInCluster.sh
#! /bin/bash

CLUSTER_CONTEXTS="cluster1 cluster2"
for c in ${CLUSTER_CONTEXTS}; do
    echo ----- ${c} -----
    kubectl --context=${c} api-resources --api-group=autoscaling
done

~/Documents/Labs/kubefed ⌚ 17:35:43
$

TBD - Federate Examples

```
