# heapster (used by kubernetes dashboard)
resource "helm_release" "heapster" {
    name      = "heapster"
    chart     = "stable/heapster"
    namespace = "kube-system"

}

# influxdb (used by heapster)
resource "helm_release" "influxdb" {
    name      = "influxdb"
    chart     = "stable/influxdb"
    namespace = "kube-system"

}

# kubernetes dashboard
resource "helm_release" "kubernetes-dashboard" {
    name      = "kubernetes-dashboard"
    chart     = "stable/kubernetes-dashboard"
    namespace = "kube-system"

    set {
        name  = "rbac.clusterAdminRole"
        value = "true"
    }

}
