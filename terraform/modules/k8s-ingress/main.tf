# helm install --name=alb \
#     --namespace ingress \
#     --set-string autoDiscoverAwsRegion=true \
#     --set-string autoDiscoverAwsVpcID=true \
#     --set clusterName=k8s.test.akomljen.com \
#     --set extraEnv \
#     akomljen-charts/alb-ingress


resource "helm_release" "aws-alb-ingress-controller" {
    name      = "aws-alb-ingress-controller"
    chart     = "incubator/aws-alb-ingress-controller"
    namespace = "kube-system"

    values = [
      "${data.template_file.values.rendered}"
    ]


}




resource "aws_iam_role" "alb_ingress_controller" {
  name                  = "k8s-${var.name}-alb-ingress-controller"
  description           = "alb-ingress-controller role for k8s cluster ${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.alb_ingress_controller_assume_role_policy.json}"
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "alb_ingress_controller" {
  policy_arn = "${aws_iam_policy.alb_ingress_controller.arn}"
  role       = "${aws_iam_role.alb_ingress_controller.name}"
}

resource "aws_iam_policy" "alb_ingress_controller" {
  name        = "k8s-${var.name}-alb-ingress-controller"
  description = "alb-ingress-controller policy for k8s cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.alb_ingress_controller_policy.json}"
}



data "aws_iam_policy_document" "alb_ingress_controller_assume_role_policy" {
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



data "aws_iam_policy_document" "alb_ingress_controller_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate"
              ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                 "ec2:AuthorizeSecurityGroupIngress",
                 "ec2:CreateSecurityGroup",
                 "ec2:CreateTags",
                 "ec2:DeleteTags",
                 "ec2:DeleteSecurityGroup",
                 "ec2:DescribeAccountAttributes",
                 "ec2:DescribeAddresses",
                 "ec2:DescribeInstances",
                 "ec2:DescribeInstanceStatus",
                 "ec2:DescribeInternetGateways",
                 "ec2:DescribeSecurityGroups",
                 "ec2:DescribeSubnets",
                 "ec2:DescribeTags",
                 "ec2:DescribeVpcs",
                 "ec2:ModifyInstanceAttribute",
                 "ec2:ModifyNetworkInterfaceAttribute",
                 "ec2:RevokeSecurityGroupIngress"
                ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                 "elasticloadbalancing:AddListenerCertificates",
                 "elasticloadbalancing:AddTags",
                 "elasticloadbalancing:CreateListener",
                 "elasticloadbalancing:CreateLoadBalancer",
                 "elasticloadbalancing:CreateRule",
                 "elasticloadbalancing:CreateTargetGroup",
                 "elasticloadbalancing:DeleteListener",
                 "elasticloadbalancing:DeleteLoadBalancer",
                 "elasticloadbalancing:DeleteRule",
                 "elasticloadbalancing:DeleteTargetGroup",
                 "elasticloadbalancing:DeregisterTargets",
                 "elasticloadbalancing:DescribeListenerCertificates",
                 "elasticloadbalancing:DescribeListeners",
                 "elasticloadbalancing:DescribeLoadBalancers",
                 "elasticloadbalancing:DescribeLoadBalancerAttributes",
                 "elasticloadbalancing:DescribeRules",
                 "elasticloadbalancing:DescribeSSLPolicies",
                 "elasticloadbalancing:DescribeTags",
                 "elasticloadbalancing:DescribeTargetGroups",
                 "elasticloadbalancing:DescribeTargetGroupAttributes",
                 "elasticloadbalancing:DescribeTargetHealth",
                 "elasticloadbalancing:ModifyListener",
                 "elasticloadbalancing:ModifyLoadBalancerAttributes",
                 "elasticloadbalancing:ModifyRule",
                 "elasticloadbalancing:ModifyTargetGroup",
                 "elasticloadbalancing:ModifyTargetGroupAttributes",
                 "elasticloadbalancing:RegisterTargets",
                 "elasticloadbalancing:RemoveListenerCertificates",
                 "elasticloadbalancing:RemoveTags",
                 "elasticloadbalancing:SetIpAddressType",
                 "elasticloadbalancing:SetSecurityGroups",
                 "elasticloadbalancing:SetSubnets",
                 "elasticloadbalancing:SetWebACL"
                ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates"

                ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL"
                ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                "tag:GetResources",
                "tag:TagResources"
                ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
                "waf:GetWebACL"
                ]
    resources = ["*"]
  }

}




data "template_file" "values" {
  template = "${file("alb-ingress-controller-values.yaml.tpl")}"
  vars = {
    cluster_name              = "${var.name}"
    rbac_create               = "true"
    auto_discover_aws_region  = "true"
    auto_discover_aws_vpc_id  = "true"
    replica_count             = "1"

  }
}















