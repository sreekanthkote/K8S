# backend state bucket/table config

provider "aws" {
  region = "${var.aws_region}"
  # xxxxxxx010 (account factory) ...all aws-xxx-base state buckets reside here
  allowed_account_ids = ["xxxxxxxxx"]
}

# current AWS account id
data "aws_caller_identity" "current" {}

#  current AWS account_alias
data "aws_iam_account_alias" "current" {}

locals{
  # user_ids = "${flist(split(":", data.aws_caller_identity.current.user_id))}"
  created_by = "${element(flatten(list(split(":", data.aws_caller_identity.current.user_id))), 1)}"
}




module "backend" {
  source        = "git@github.com:xxxxxxx/tf-aws-s3-state.git"
  bucket        = "${var.name}"
  bucket_suffix = "tfstate-${var.aws_region}-xxxxxxx-uk"
  aws_region    = "${var.aws_region}"
  common_tags = {
    terraform           = "true"
    component           = "tf-state-bucket"
    environment         = "sbx"
    created_by          = "${local.created_by}"
  }
}

variable "aws_region" {}
variable "name" {}
