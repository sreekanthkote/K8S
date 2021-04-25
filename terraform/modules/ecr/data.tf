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






# arn:aws:iam::xxxxxxxxxx:instance-profile/v3-hydra-sbx20190207180433775100000009, arn:aws:iam::363750804736:instance-profile/v3-hydra-sbx2019020718043377530000000a
