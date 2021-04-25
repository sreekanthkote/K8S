helm install stable/cluster-autoscaler \
    --name aws-cluster-autoscaler \
    --namespace kube-system \
    --set autoDiscovery.clusterName=v3-hydra-sbx \
    --set awsRegion=eu-west-1 \
    --set sslCertPath=/etc/kubernetes/pki/ca.crt \
    --set rbac.create=true
