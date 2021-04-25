# current AWS account id
data "aws_caller_identity" "current" {}

#  current AWS account_alias
data "aws_iam_account_alias" "current" {}

# Get AWS AZ zones
data "aws_availability_zones" "available" {}

locals{
  # user_ids = "${flist(split(":", data.aws_caller_identity.current.user_id))}"
  created_by = "${element(flatten(list(split(":", data.aws_caller_identity.current.user_id))), 1)}"
}





# get EKS remote state file ...to retrieve worker node role
data "terraform_remote_state" "eks" {
  backend = "s3"
  config {
    bucket = "${var.name}-tfstate-eu-west-1-rwrd-uk"
    key      = "eks.tfstate"
    region   = "eu-west-1"
  }
}
