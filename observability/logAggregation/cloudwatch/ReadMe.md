# General Notes

## Container Insights
[Reference](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html)

## FluentD Daemonset to send logs to CloudWatch
1. Create Cloudwtach Namespace
```
kubectl apply -f createCloudWatchNamespace.yml
```
2. Create fluentd Deployment
```
kubectl create configmap cluster-info \
--from-literal=cluster.name=cluster_name \
--from-literal=logs.region=region_name -n amazon-cloudwatch


kubectl apply -f fluentdDeploymentTemplate.yml

kubectl get pods -n amazon-cloudwatch
```
3. Verify
```
kubectl get pods -n amazon-cloudwatch

kubectl logs pod_name -n amazon-cloudwatch
```
