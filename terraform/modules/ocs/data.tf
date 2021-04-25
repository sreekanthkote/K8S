# current AWS account id
data "aws_caller_identity" "current" {}

#  current AWS account_alias
data "aws_iam_account_alias" "current" {}

# Get AWS AZ zones
data "aws_availability_zones" "available" {}

# get current AWS region
data "aws_region" "current" {}

locals{
  # user_ids = "${flist(split(":", data.aws_caller_identity.current.user_id))}"
  created_by = "${element(flatten(list(split(":", data.aws_caller_identity.current.user_id))), 1)}"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config {
    bucket = "${var.name}-tfstate-eu-west-1-rwrd-uk"
    key      = "eks.tfstate"
    region   = "eu-west-1"
  }
}

# route53 private zone id - int
data "aws_route53_zone" "dev" {
  name         = "dev.rwrd007.rewardcloud.net."
  private_zone = false
}

# route53 private zone id - int
# data "aws_route53_zone" "demo" {
#   name         = "demo.rwrd007.rewardcloud.net."
#   private_zone = false
# }
