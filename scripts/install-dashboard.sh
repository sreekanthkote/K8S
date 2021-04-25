helm install stable/heapster \
	--name heapster

helm install stable/influxdb \
	--name influxdb


helm install stable/kubernetes-dashboard \
	--name kubernetes-dashboard \
	--set=rbac.clusterAdminRole=true
