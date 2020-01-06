## Ksync Demo:

### Install Ksync
```
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (10:56:28)
ζ curl https://ksync.github.io/gimme-that/gimme.sh | bash                                                  [813bd9b]
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2758  100  2758    0     0   6599      0 --:--:-- --:--:-- --:--:--  6613
Checking GitHub for the latest release of ksync
Found release tag: 0.4.1
Downloading ksync_darwin_amd64
No previous install found. Installing ksync to /usr/local/bin/ksync
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (10:57:34)
ζ which ksync                                                                                              [813bd9b]
/usr/local/bin/ksync
```

### Deploy a Sample App
```
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (10:59:00)
ζ kubectl apply -f https://ksync.github.io/ksync/example/app/app.yaml                                      [813bd9b]
service/app created
deployment.apps/app created
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:00:01)
ζ kubectl get po --selector=app=app                                                                        [813bd9b]
NAME                   READY   STATUS              RESTARTS   AGE
app-57c6b5c8c5-qgrfq   0/1     ContainerCreating   0          7s
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:00:09)
ζ kubectl get po --selector=app=app                                                                        [813bd9b]
NAME                   READY   STATUS    RESTARTS   AGE
app-57c6b5c8c5-qgrfq   1/1     Running   0          28s
```

### Set-up Portforward to be able to hit the pod in my kube cluster
```
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:00:29)
ζ kubectl get po --selector=app=app -o=custom-columns=:metadata.name --no-headers | xargs -IPOD kubectl port-forward POD 8080:80 &
[1] 78170 78171
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:00:30)
ζ curl localhost:8080                                                                                      [813bd9b]
\Handling connection for 8080
{"files":[{"mtime":1571260255.0,"name":"Dockerfile"},{"mtime":1571414480.0,"name":"Makefile"},{"mtime":1571260255.0,"name":"requirements.txt"},{"mtime":1571260255.0,"name":"app.yaml"},{"mtime":1571260255.0,"name":"server.py"},{"mtime":1578268814.9920986,"name":"__pycache__/server.cpython-38.pyc"}],"pod":"app-57c6b5c8c5-qgrfq","restart":"Mon, 06 Jan 2020 00:00:14 GMT"}
```

### Initialize ksync and install the server-side component on your cluster

Initialize ksync and install the server component on your cluster. The server component is a DaemonSet that provides access to each node's filesystem. This will also go through a set of pre and postflight checks to verify that everything is working correctly. You can run these yourself by using ksync doctor.

```
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:00:49)
ζ ksync init                                                                                               [813bd9b]
==== Local Environment ====
Fetching extra binaries                     ✓

==== Preflight checks ====
Cluster Config                              ✓
Cluster Connection                          ✓
Cluster Version                             ✓
Cluster Permissions                         ✓

==== Cluster Environment ====
Adding ksync to the cluster                 ✓
Waiting for pods to be healthy              ✓

==== Postflight checks ====
Cluster Service                             ✓
Service Health                              ✓
Service Version                             ✓
Docker Version                              ✓
Docker Storage Driver                       ✓
Docker Storage Root                         ✓
import datetime

==== Initialization Complete ====
import datetime
```

### Startup the local client

Startup the local client. It watches your local config to start new jobs and the kubernetes API to react when things change. This will just put it into the background. Feel free to run in a separate terminal or add as a service to your host.

```
#  kiran@mymachine: ~/Downloads/myrepo <authtest ✔ > (11:02:01)
ζ ksync watch --daemon                                                                                     [813bd9b]
INFO[0000] Sending watch to the background. Use clean to stop it.

````


### Create a new Spec (watch will look out for configured specs and start syncing files when required)
```
#  kiran@mymachine: ~/Downloads/ksynctest                                               (11:02:32)
ζ mkdir -p $(pwd)/ksync
#  kiran@mymachine: ~/Downloads/ksynctest                                               (11:02:41)
ζ ksync create --selector=app=app $(pwd)/ksync /code

ζ ksync get
       NAME        LOCAL   REMOTE    STATUS            POD            CONTAINER
+----------------+-------+--------+----------+----------------------+-----------+
  skilled-bobcat   ksync   /code
                                    starting   app-57c6b5c8c5-qgrfq

#  kiran@mymachine: ~/Downloads/ksynctest                                               (11:02:53)
ζ ls -l ksync
total 40
-rw-r--r--  1 kiranmuddukrishna  staff   219 17 Oct 08:10 Dockerfile
-rw-r--r--  1 kiranmuddukrishna  staff   148 19 Oct 03:01 Makefile
drwxr-xr-x  3 kiranmuddukrishna  staff    96  6 Jan 11:02 __pycache__
-rw-r--r--  1 kiranmuddukrishna  staff  1014 17 Oct 08:10 app.yaml
-rw-r--r--  1 kiranmuddukrishna  staff     6 17 Oct 08:10 requirements.txt
-rw-r--r--  1 kiranmuddukrishna  staff   701 17 Oct 08:10 server.py
```

### Now Ksync in action
Now edit server.py to add a key - "ksync":true. Take a look at the status now. It should be reloading the remote container. - "ksync get"

Then verify that the new container is live and has the new key in the response.

```
#  kiran@mymachine: ~/Downloads/ksynctest                                               (11:04:17)
ζ curl localhost:8080
Handling connection for 8080
{"files":[{"mtime":1578269054.355447,"name":"server.py"},{"mtime":1571260255.0,"name":"Dockerfile"},{"mtime":157141448{"files":[{"mtime":1571260255.0,"name":"Dockerfile"},{"mtime":1571414480.0,"name":"Makefile"},{"mtime":1571260255.0,"n0.0,"name":"Makefile"},{"mtime":1571260255.0,"name":"requirements.txt"},{"mtime":1571260255.0,"name":"app.yaml"},{"mtime":1578269056.3528814,"name":"__pycache__/server.cpython-38.pyc"}],"ksync":true,"pod":"app-57c6b5c8c5-qgrfq","restart":"Mon, 06 Jan 2020 00:04:16 GMT"}
```

### Clean-up
```
# kiran@mymachine: ~/Downloads/ksynctest                                               (11:20:14)
ζ kubectl delete -f https://ksync.github.io/ksync/example/app/app.yaml
service "app" deleted
deployment.apps "app" deleted
# kiran@mymachine: ~/Downloads/ksynctest                                               (11:21:10)
ζ ps auxwww | grep 78171
kiran 95832   0.0  0.0  4409328    900 s009  S+   11:21am   0:00.00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn 78171
kiran 78171   0.0  0.0  4400100    824 s009  SN   11:00am   0:00.01 xargs -IPOD kubectl port-forward POD 8080:80
# kiran@mymachine: ~/Downloads/ksynctest                                               (11:21:21)
ζ kill -9 78171
[1]  + 78170 done       kubectl get po --selector=app=app -o=custom-columns=:metadata.name  |
       78171 killed     xargs -IPOD kubectl port-forward POD 8080:80
```
