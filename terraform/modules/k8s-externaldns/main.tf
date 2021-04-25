# externaldns role to be used by kube2iam
resource "aws_iam_role" "externaldns" {
  # name_prefix           = "k8s-${var.name}-externaldns"
  name                  = "k8s-${var.name}-externaldns"
  description           = "ExternalDNS role for k8s cluster ${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.externaldns_assume_role_policy.json}"
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "externaldns" {
  policy_arn = "${aws_iam_policy.externaldns.arn}"
  role       = "${aws_iam_role.externaldns.name}"
}

resource "aws_iam_policy" "externaldns" {
  name        = "k8s-${var.name}-externaldns"
  description = "ExternalDNS policy for k8s cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.externaldns_policy.json}"
}



data "aws_iam_policy_document" "externaldns_assume_role_policy" {
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



data "aws_iam_policy_document" "externaldns_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["route53:ListHostedZones",
              "route53:ListResourceRecordSets"
              ]
    # allow kube2iam to assume any role with a k8s- prefix. eg k8s-s3
    resources = ["*"]
  }
}


# Route53 zone?





# ExternalDNS



 # helm install stable/external-dns --name externaldns \
 #    --set=rbac.create=true,aws.roleArn=k8s-v3-hydra-sbx-externaldns,provider=aws


resource "helm_release" "external-dns" {
    name      = "external-dns"
    chart     = "stable/external-dns"
    namespace = "kube-system"


    # values = [
    #   "${file("values.yaml")}"
    # ]

    values = [
      "${data.template_file.values.rendered}"
    ]



    # set {
    #     name  = "rbac.create"
    #     value = "true"
    # }

    # set {
    #     name  = "aws.roleArn"
    #     value = "${aws_iam_role.externaldns.arn}"
    # }

    # set_string {
    #     name  = "podAnnotations"
    #     value = "'iam.amazonaws.com/role': 'k8s-v3-hydra-sbx-externaldns'"
    # }

    # set {
    #     name  = "provider"
    #     value = "aws"
    # }

    # set {
    #     name  = "logLevel"
    #     value = "info"
    # }


    # set {
    #     name  = "dryRun"
    #     value = "true"
    # }


}

data "template_file" "values" {
  template = "${file("values.yaml.tpl")}"
  vars = {
    externaldns_rolearn = "${aws_iam_role.externaldns.arn}"
  }
}

