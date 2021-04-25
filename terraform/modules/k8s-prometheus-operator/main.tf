
resource "helm_release" "prometheus-operator" {
    name      = "prometheus-operator"
    chart     = "stable/prometheus-operator"
    namespace = "kube-system"

    # set {
    #     name  = ""
    #     value = ""
    # }

}




# # prometheus
# resource "helm_release" "prometheus" {
#     name      = "prometheus"
#     chart     = "stable/prometheus"
#     namespace = "kube-system"

#     # set {
#     #     name  = ""
#     #     value = ""
#     # }

# }

# # grafana
# resource "helm_release" "grafana" {
#     name      = "grafana"
#     chart     = "stable/grafana"
#     namespace = "kube-system"

#     # set {
#     #     name  = ""
#     #     value = ""
#     # }

# }



# # kube state metrics ...generates and exposes cluster level metrics
# resource "helm_release" "kube-state-metrics" {
#     name      = "kube-state-metrics"
#     chart     = "stable/kube-state-metrics"
#     namespace = "kube-system"

#     # set {
#     #     name  = ""
#     #     value = ""
#     # }

# }
