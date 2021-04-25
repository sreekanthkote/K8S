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
