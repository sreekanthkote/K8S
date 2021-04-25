# cluster autoscaler to scale nodes
resource "helm_release" "cluster-autoscaler" {
    name      = "cluster-autoscaler"
    chart     = "stable/cluster-autoscaler"
    namespace = "kube-system"


    values = [
      "${data.template_file.values.rendered}"
    ]


    # set {
    #     name  = "autoDiscovery.clusterName"
    #     value = "v3-hydra-sbx"
    # }

    # set {
    #     name  = "awsRegion"
    #     value = "eu-west-1"
    # }

    # set {
    #     name  = "sslCertPath"
    #     value = "/etc/kubernetes/pki/ca.crt"
    # }

    # set {
    #     name  = "rbac.create"
    #     value = "true"
    # }

}




data "template_file" "values" {
  template = "${file("cluster-autoscaler-values.yaml.tpl")}"
  vars = {
    cluster_name    = "${var.name}"
    ssl_cert_path   = "/etc/kubernetes/pki/ca.crt"
    rbac_create     = "true"
  }
}



# cluster autoscaler role to be used by kube2iam
resource "aws_iam_role" "cluster_autoscaler" {
  name                  = "k8s-${var.name}-cluster_autoscaler"
  description           = "ExternalDNS role for k8s cluster ${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json}"
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = "${aws_iam_policy.cluster_autoscaler.arn}"
  role       = "${aws_iam_role.cluster_autoscaler.name}"
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "k8s-${var.name}-cluster-autoscaler"
  description = "cluster_autoscaler policy for k8s cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.cluster_autoscaler_policy.json}"
}



data "aws_iam_policy_document" "cluster_autoscaler_assume_role_policy" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.terraform_remote_state.eks.kube2iam_worker_iam_role_arn}"]
    }
  }

}



data "aws_iam_policy_document" "cluster_autoscaler_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["autoscaling:DescribeAutoScalingGroups",
               "autoscaling:DescribeAutoScalingInstances",
               "autoscaling:DescribeLaunchConfigurations",
               "autoscaling:DescribeTags",
               "autoscaling:SetDesiredCapacity",
               "autoscaling:TerminateInstanceInAutoScalingGroup"
              ]
    resources = ["*"]
  }
}












# Metrics server ...enables horizontal pod autoscaler(HPA) autoscaler API
resource "helm_release" "metrics-server" {
    name      = "metrics-server"
    chart     = "stable/metrics-server"
    namespace = "kube-system"

}



# Prometheus adapter for the custom metrics API. Complements metrics server
# https://banzaicloud.com/blog/k8s-horizontal-pod-autoscaler/
# resource "helm_release" "prometheus-adapter" {
#     name      = "prometheus-adapter"
#     chart     = "stable/prometheus-adapter"
#     namespace = "kube-system"

#     set {
#         name  = "logLevel"
#         value = "4"
#     }

#     set {
#         name  = "metricsRelistInterval"
#         value = "1m"
#     }

#     set {
#         name  = "prometheus.url"
#         value = ""
#     }

#     set {
#         name  = "prometheus.port"
#         value = ""
#     }

# }


# kube-downscaler



# vertical pod autoscaler
