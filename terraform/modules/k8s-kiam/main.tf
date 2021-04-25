
# helm install stable/kiam --name my-release \
#   --set=extraArgs.base-role-arn=arn:aws:iam::0123456789:role/,extraArgs.default-role=kube2iam-default,host.iptables=true,host.interface=eni+


resource "helm_release" "kiam" {
    name      = "kiam"
    chart     = "stable/kiam"
    namespace = "kube-system"

    set {
        name  = ""
        value = ""
    }


}

