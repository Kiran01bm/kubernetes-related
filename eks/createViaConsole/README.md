# Create EKS Cluster via AWS Console

## Procedure (with Default selections where possible):

### Create EKS Cluster
1. Choose Cluster Name
2. Select Kubernetes version
3. Create an IAM Role for the EKS Service and attach  the following permissions policies
    a. AmazonEKSClusterPolicy - This policy provides Kubernetes the permissions it requires to manage resources on your behalf. Kubernetes requires Ec2:CreateTags permissions to place identifying information on EC2 resources including but not limited to Instances, Security Groups, and Elastic Network Interfaces.
    b. AmazonEKSServicePolicy - This policy allows Amazon Elastic Container Service for Kubernetes to create and manage the necessary resources to operate EKS Clusters.
4. Select a VPC - For HA multi-AZ ex: us-east-2
6. Select Subnets - For HA subnets from multiple AZs ex: us-east-2a, us-east-2b, s-east-2c
7. Create and apply an appropriate SG

### Configure kubectl to connect to the cluster
1. Install aws cli
2. Install aws-iam-authenticator - `go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator`
3. Configure the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION for the IAM User and Region used via console respectively
4. Run `aws eks update-kubeconfig --name CLUSTER_NAME`
5. Verify the set-up by running  any kubectl command that queries the api server ex: `kubectl get svc`

## How does aws-iam-authenticator work ? 
Detailed info see [How does auth work in EKS with IAM Users ](http://marcinkaszynski.com/2018/07/12/eks-auth.html)
Once Kubernets cluster and Kubectl is configured, A call from kubectl to the Kubernetes API server will firstly pass a bearer token, by way of a webhook, over to IAM to ensure that the request is coming from a valid identity. Once the validity of the identity has been confirmed, Kubernetes then uses it's own RBAC capability (Role Based Access Control) to approve or deny the specific action the requester tried to perform.

#### Obtaining token:
ex: `aws-iam-authenticator token -i CLUSTER_NAME`

#### kube config user entry:
```yaml
- name: arn:aws:eks:us-east-2:ACCOUNTID:cluster/demo
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
     . token
     . -i
     . demo
      command: aws-iam-authenticator
```
