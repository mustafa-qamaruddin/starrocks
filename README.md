**⚠️ Warning: If you need to expose multiple ports simultaneously (e.g., port 8030 for StarRocks and another port for Grafana), consider using Docker Compose instead of Kubernetes for easier management. **


**⚠️ Warning: Configurations for StarRocks Frontend/Backend could better be loaded from external files, but that requires forking the main chart, since Helm functions work only inside chart and not values files. https://helm.sh/docs/chart_template_guide/accessing_files/ **

## Screenshots

### Screenshot 1
![Screenshot 1](images/Screenshot_01.png)

### Screenshot 2
![Screenshot 2](images/Screenshot_02.png)

# Links

- https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/doc/local_installation_how_to.md
- https://github.com/StarRocks/starrocks-kubernetes-operator/tree/main/examples/starrocks
- https://github.com/StarRocks/starrocks-kubernetes-operator/tree/main/doc
- https://docs.starrocks.io/docs/deployment/helm/
- https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/helm-charts/charts/kube-starrocks/values.yaml
- https://artifacthub.io/packages/helm/kube-starrocks/kube-starrocks?modal=values
- https://github.com/StarRocks/starrocks-kubernetes-operator

# Setup

´´´

minikube start --memory 7854 --cpus=4 --driver=docker



minikube config set cpus 4
minikube config set memory 7854

helm repo add starrocks https://starrocks.github.io/starrocks-kubernetes-operator
helm repo update

helm upgrade --install -f  /Users/mustafa/Documents/starrocks-project/values.yml starrocks starrocks/kube-starrocks

helm install -f /Users/mustafa/Documents/starrocks-project/values.yml starrocks starrocks/kube-starrocks

kubectl --namespace default get starrockscluster -l "cluster=kube-starrocks"

kubectl port-forward pods/kube-starrocks-fe-0 9030:9030

´´´


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-prometheus-pushgateway.default.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9091

