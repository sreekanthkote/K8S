data "aws_iam_policy_document" "cmk_key_policy" {
  statement {
    sid = "1"

    effect = "Allow"

    principals = {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }
}


data "template_file" "cmk_key_policy" {
  template = "${file("${path.module}/cmk_key_policy.json.tpl")}"

  vars {
    aws_account_id="${data.aws_caller_identity.current.account_id}"
  }
}



module "kms_key" {
  source = "git@github.com:xxxxxxxx/tf-aws-kms.git//?ref=v0.1"

  alias_name              = "v3-hydra-sbx-kms"
  description             = "Hydra sandbox KMS key"
  deletion_window_in_days = 7
  key_policy              = "${data.template_file.cmk_key_policy.rendered}"
  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }
}
