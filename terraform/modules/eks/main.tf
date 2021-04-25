



# alb ingress controller role
# this allows all of the pods in the cluster to access the alb ingress controller
# kube2iam provides more control...
# resource "aws_iam_role_policy_attachment" "alb_ingress_controller_eks_policy_attachment" {
#   policy_arn = "${aws_iam_policy.alb_ingress_controller_eks_policy.arn}"
#   role       = "${module.eks.worker_iam_role_name}"
# }

# resource "aws_iam_policy" "alb_ingress_controller_eks_policy" {
#   name_prefix = "albIngressControllerEksPolicy"
#   description = "ALB ingress controller eks policy"
#   policy      = "${data.aws_iam_policy_document.alb_ingress_controller_eks.json}"
# }

# data "aws_iam_policy_document" "alb_ingress_controller_eks" {
#   statement {

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "acm:DescribeCertificate",
#       "acm:ListCertificates",
#       "acm:GetCertificate"
#       ]

#     resources = ["*"]

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:CreateSecurityGroup",
#       "ec2:CreateTags",
#       "ec2:DeleteTags",
#       "ec2:DeleteSecurityGroup",
#       "ec2:DescribeInstances",
#       "ec2:DescribeInstanceStatus",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeTags",
#       "ec2:DescribeVpcs",
#       "ec2:ModifyInstanceAttribute",
#       "ec2:ModifyNetworkInterfaceAttribute",
#       "ec2:RevokeSecurityGroupIngress"
#       ]

#     resources = ["*"]

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "iam:GetServerCertificate",
#       "iam:ListServerCertificates"
#       ]

#     resources = ["*"]

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "waf-regional:GetWebACLForResource",
#       "waf-regional:GetWebACL",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL"
#       ]

#     resources = ["*"]

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "tag:GetResources",
#       "tag:TagResources"
#       ]

#     resources = ["*"]

#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"

#     actions = [
#       "waf:GetWebACL"
#       ]

#     resources = ["*"]

#   }

# }


#--------------------------------------------------------------------------------------------

# kube2iam role
# https://github.com/jtblin/kube2iam
# https://blog.csanchez.org/2018/06/12/installing-kube2iam-in-aws-kubernetes-kops-cluster/


resource "aws_iam_role" "workers" {
  name_prefix           = "${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.workers_assume_role_policy.json}"
  force_detach_policies = true
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = "${var.name}"
  # role        = "${lookup(var.worker_groups[count.index], "iam_role_id",  lookup(local.workers_group_defaults, "iam_role_id"))}"
  role          = "${aws_iam_role.workers.id}"
  # count       = "${var.worker_group_count}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.workers.name}"
}

# resource "null_resource" "tags_as_list_of_maps" {
#   count = "${length(keys(var.tags))}"

#   triggers = {
#     key                 = "${element(keys(var.tags), count.index)}"
#     value               = "${element(values(var.tags), count.index)}"
#     propagate_at_launch = "true"
#   }
# }

resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = "${aws_iam_policy.worker_autoscaling.arn}"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_policy" "worker_autoscaling" {
  name_prefix = "eks-worker-autoscaling-${var.name}"
  description = "EKS worker node autoscaling policy for cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.worker_autoscaling.json}"
}

data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}



# kube2iam
resource "aws_iam_role_policy_attachment" "kube2iam_eks_policy_attachment" {
  policy_arn = "${aws_iam_policy.kube2iam_eks_policy.arn}"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_policy" "kube2iam_eks_policy" {
  name_prefix = "eks-worker-kube2iam-${var.name}"
  description = "EKS worker node kube2iam policy for cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.kube2iam_eks_policy.json}"
}



data "aws_iam_policy_document" "kube2iam_eks_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    # allow kube2iam to assume any role with a k8s- prefix. eg k8s-s3
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/k8s-*"]
  }
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}












locals {
  cluster_name = "${var.name}"

  # the commented out worker group list below shows an example of how to define
  # multiple worker groups of differing configurations
  # worker_groups = [
  #   {
  #     asg_desired_capacity = 2
  #     asg_max_size = 10
  #     asg_min_size = 2
  #     instance_type = "m4.xlarge"
  #     name = "worker_group_a"
  #     additional_userdata = "echo foo bar"
  #     subnets = "${join(",", module.vpc.private_subnets)}"
  #   },
  #   {
  #     asg_desired_capacity = 1
  #     asg_max_size = 5
  #     asg_min_size = 1
  #     instance_type = "m4.2xlarge"
  #     name = "worker_group_b"
  #     additional_userdata = "echo foo bar"
  #     subnets = "${join(",", module.vpc.private_subnets)}"
  #   },
  # ]

  # iam_role_id = ${element(concat(aws_iam_role.workers.*.id, list("")), 0)}


  worker_groups = [
    {
        name = "wg-blue"
        # instance_type               = "t3.medium"
        instance_type               = "${var.wg_blue_instance_type}"
        ami_id                      = "${var.wg_blue_ami_id}"
        spot_price                  = "${var.wg_blue_spot_price}"
        autoscaling_enabled         = "${var.wg_blue_autoscaling_enabled}"
        protect_from_scale_in       = "${var.wg_blue_protect_from_scale_in}"
        asg_desired_capacity        = "${var.wg_blue_asg_desired_capacity}"
        asg_max_size                = "${var.wg_blue_asg_max_size}"
        asg_min_size                = "${var.wg_blue_asg_min_size }"
        subnets                     = "${join(",", data.aws_subnet_ids.private_subnets.ids)}"
        iam_role_id                 = "${aws_iam_role.workers.name}"
    },

    {
      name = "wg-green"
      instance_type               = "${var.wg_green_instance_type}"
      ami_id                      = "${var.wg_green_ami_id}"
      # spot_price                  = "${var.wg_green_spot_price}"
      autoscaling_enabled         = "${var.wg_green_autoscaling_enabled}"
      protect_from_scale_in       = "${var.wg_green_protect_from_scale_in}"
      asg_desired_capacity        = "${var.wg_green_asg_desired_capacity}"
      asg_max_size                = "${var.wg_green_asg_max_size}"
      asg_min_size                = "${var.wg_green_asg_min_size }"
      subnets                     = "${join(",", data.aws_subnet_ids.private_subnets.ids)}"
      iam_role_id                 = "${aws_iam_role.workers.id}"
    },
  ]

  tags = {
    terraform = "true"
    created_by = "${local.created_by}"
    environment = "sbx"
    project_name = "hydra"
  }
}


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${data.aws_vpc.vpc.cidr_block}",
    ]
  }
}


locals {
  map_roles = [
    {
      role_arn = "${data.aws_iam_role.xxxxx9.arn}"
      username = "role1"
      group    = "system:masters"
    },
  ]
}



module "eks" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-eks//?ref=v2.1.0"
  cluster_name                         = "${var.name}"
  cluster_version                      = "${var.cluster_version}"
  vpc_id                               = "${data.aws_vpc.vpc.id}"
  subnets                              = "${data.aws_subnet_ids.private_subnets.ids}"
  worker_group_count                   = "${var.worker_group_count}"
  worker_groups                        = "${local.worker_groups}"
  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
  map_roles                            = "${local.map_roles}"
  tags                                 = "${local.tags}"
}


# Workaround ...protect_from_scale_in = true, prevents the instances in an ASG from being deleted, and hence the ASG itself,  in a destroy
resource "null_resource" "eks-predestroy" {
    provisioner "local-exec" {
    when = "destroy"

    interpreter = ["/bin/bash", "-c"]

    command = <<CMD
ASGName=$(aws autoscaling describe-auto-scaling-groups | grep "${local.cluster_name}" -A 100 -B 100 | grep AutoScalingGroupName | tr -d '" ,' | cut -f2 -d ":")

for asg in $ASGName; do
    InstanceID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "$asg" | grep InstanceId | tr -d '" ,' | cut -f2 -d ":")

    for instance in $InstanceID; do
        aws autoscaling set-instance-protection --instance-ids "$instance" --auto-scaling-group-name "$asg" --no-protected-from-scale-in

    done
done
CMD
    }
}
