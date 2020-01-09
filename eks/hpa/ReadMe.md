## General Notes

### HPA
1. Deploy the metrics server ex:
```
helm install stable/metrics-server \
    --name metrics-server \
    --version 2.0.4 \
    --namespace metrics
```

2. Verify
```
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```

3. Deploy sample app
```
kubectl run php-apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --expose --port=80
```

4. Deploy HPA
```
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

5. View HPA with Targets, Min, Max etc
```
kubectl get hpa -w
```
