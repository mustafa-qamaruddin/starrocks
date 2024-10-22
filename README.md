**⚠️ Warning: If you need to expose multiple ports simultaneously (e.g., port 8030 for StarRocks and another port for Grafana), consider using Docker Compose instead of Kubernetes for easier port management. **


**⚠️ Warning: Configurations for StarRocks Frontend/Backend could better be loaded from external files, but that requires forking the main chart, since Helm functions work only inside chart and not values files. https://helm.sh/docs/chart_template_guide/accessing_files/ **

## Screenshots

### Screenshot 1
![Screenshot 1](images/Screenshot_01.png)

### Screenshot 2
![Screenshot 2](images/Screenshot_02.png)

# StarRocks Setup

´´´

minikube start --memory 7854 --cpus=4 --driver=docker

minikube config set cpus 4
minikube config set memory 7854

helm repo add starrocks https://starrocks.github.io/starrocks-kubernetes-operator
helm repo update

helm install -f /Users/mustafa/Documents/starrocks-project/starrocks/values.yml starrocks starrocks/kube-starrocks

helm upgrade --install -f  /Users/mustafa/Documents/starrocks-project/starrocks/values.yml starrocks starrocks/kube-starrocks

kubectl --namespace default get starrockscluster -l "cluster=kube-starrocks"

kubectl port-forward pods/kube-starrocks-fe-0 9030:9030

´´´

# StarRocks Links

- https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/doc/local_installation_how_to.md
- https://github.com/StarRocks/starrocks-kubernetes-operator/tree/main/examples/starrocks
- https://github.com/StarRocks/starrocks-kubernetes-operator/tree/main/doc
- https://docs.starrocks.io/docs/deployment/helm/
- https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/helm-charts/charts/kube-starrocks/values.yaml
- https://artifacthub.io/packages/helm/kube-starrocks/kube-starrocks?modal=values
- https://github.com/StarRocks/starrocks-kubernetes-operator

# Superset Setup

```
helm repo add superset https://apache.github.io/superset
helm search repo superset
helm upgrade --install --values /Users/mustafa/Documents/starrocks-project/superset/values.yml superset superset/superset

helm uninstall superset
```

# Superset Links

* https://superset.apache.org/docs/installation/kubernetes/
* https://github.com/apache/superset/blob/master/helm/superset/values.yaml

# Known Issues

## Redis Dependency

```
default     90s         Warning   BackOff                 pod/superset-worker-6f9d99c6cf-h2557               Back-off restarting failed container wait-for-postgres-redis in pod superset-worker-6f9d99c6cf-h2557_default(b8071b4c-aac5-423d-8aab-e4627e356d98)
```

```
  initContainers:
    - name: wait-for-postgres-redis
      image: "{{ .Values.initImage.repository }}:{{ .Values.initImage.tag }}"
      imagePullPolicy: "{{ .Values.initImage.pullPolicy }}"
      envFrom:
        - secretRef:
            name: "{{ tpl .Values.envFromSecret . }}"
      command:
        - /bin/sh
        - -c
        - dockerize -wait "tcp://$DB_HOST:$DB_PORT" -wait "tcp://$REDIS_HOST:$REDIS_PORT" -timeout 120s
```

Solution: Remove `-wait "tcp://$REDIS_HOST:$REDIS_PORT"`
Eventually: Removed all references to redis

## Celery Dependency
```
    Liveness:  exec [sh -c celery -A superset.tasks.celery_app:app inspect ping -d celery@$HOSTNAME] delay=120s timeout=60s period=60s #success=1 #failure=3
```

```
  Warning  BackOff    71s (x52 over 15m)  kubelet            Back-off restarting failed container superset in pod superset-worker-8485dd5db7-bwxdn_default(385178e7-8933-4f65-b1ba-f03b4f123208)
```

```
  superset:
    Container ID:  docker://62c368fd3ca4d997917dd1485e0c08cccb948ab05fe2c0d85b5b1d1d9212f809
    Image:         apachesuperset.docker.scarf.sh/apache/superset:4.0.1
    Image ID:      docker-pullable://apachesuperset.docker.scarf.sh/apache/superset@sha256:ab9467fd712cbe3738d1a7d574d6230c0b04a88af5e5e11f3fbc38e2af305162
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
      . /app/pythonpath/superset_bootstrap.sh; celery --app=superset.tasks.celery_app:app worker
```

Solution: Add celery beat
