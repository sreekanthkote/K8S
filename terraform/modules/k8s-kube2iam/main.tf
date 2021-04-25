
# helm install stable/kube2iam --name kube2iam \
#   --namespace kube-system \
#   --set=rbac.create=true,extraArgs.auto-discover-base-arn=true,extraArgs.auto-discover-default-role=true,host.iptables=true,host.interface=eni+



resource "helm_release" "kube2iam" {
    name      = "kube2iam"
    chart     = "stable/kube2iam"
    namespace = "kube-system"

    set {
        name  = "host.iptables"
        value = "false"
    }

    set {
        name  = "rbac.create"
        value = "true"
    }

    set {
        name  = "extraArgs.auto-discover-base-arn"
        value = "true"
    }

    set {
        name  = "extraArgs.auto-discover-default-role"
        value = "true"
    }


    set {
        name  = "host.interface"
        value = "eni+"
    }

    set {
        name  = "verbose"
        value = "true"
    }


}




# k8s-test-s3

# module "bucket" {
#   source            = "git@github.com:rewardinsight/tf-aws-s3?ref=v0.1"
#   bucket            = "s3-test"
#   bucket_suffix     = "eu-west-1-rwrd-uk"
#   acl               = "private"
#   sse_algorithm     = "AES256"
#   force_destroy     = "true"
#   enable_versioning = false
#   enable_random_id_suffix = true
#   common_tags  = {
#     "terraform"   =  "true"
#     "created_by"  =  "${local.created_by}"
#   }
# }




# resource "aws_iam_role" "test_s3" {
#   name                  = "k8s-${var.name}-test-s3"
#   description           = "Test S3 role for k8s cluster ${var.name}"
#   assume_role_policy    = "${data.aws_iam_policy_document.test_s3_assume_role_policy.json}"
#   force_detach_policies = true
# }


# resource "aws_iam_role_policy_attachment" "test_s3" {
#   policy_arn = "${aws_iam_policy.test_s3.arn}"
#   role       = "${aws_iam_role.test_s3.name}"
# }

# resource "aws_iam_policy" "test_s3" {
#   name        = "k8s-${var.name}-test-s3"
#   description = "test s3 policy for k8s cluster ${var.name}"
#   policy      = "${data.aws_iam_policy_document.test_s3_policy.json}"
# }



# data "aws_iam_policy_document" "test_s3_assume_role_policy" {
#   statement {
#     sid = ""

#     actions = [
#       "sts:AssumeRole",
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }

#   statement {
#     sid = ""

#     actions = [
#       "sts:AssumeRole",
#     ]

#     principals {
#       type        = "AWS"
#       identifiers = ["${data.terraform_remote_state.eks.kube2iam_worker_iam_role_arn}"]
#     }
#   }

# }



# data "aws_iam_policy_document" "test_s3_policy" {
#   statement {
#     sid     = ""
#     effect  = "Allow"
#     actions = ["route53:ChangeResourceRecordSets"]
#     resources = ["arn:aws:route53:::hostedzone/*"]
#   }

#   statement {
#     sid     = ""
#     effect  = "Allow"
#     actions = ["s3:*"]
#     resources = ["arn:aws:s3:::${module.bucket.id}"]
#   }
# }


