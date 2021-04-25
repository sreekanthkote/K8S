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

# vpc id, cidr etc, Name = name
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["v3-hydra-sandbox"]
  }
}

# subnet ids, subnet_type = public
data "aws_subnet_ids" "private_subnets" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    subnet_type = "private"
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    subnet_type = "public"
  }
}

# route53 private zone id - int
data "aws_route53_zone" "selected" {
  name         = "int.xxxxxx.xxxx.net."
  private_zone = true
}
