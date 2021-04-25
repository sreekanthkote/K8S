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

# vpc id, cidr etc, Name = name ..v3-hydra-sandbox
data "aws_vpc" "vpc_v3" {
  filter {
    name   = "tag:Name"
    values = ["v3-hydra-sandbox"]
  }
}

# subnet ids, subnet_type = public
data "aws_subnet_ids" "v3_private_subnets" {
  vpc_id = "${data.aws_vpc.vpc_v3.id}"

  tags {
    subnet_type = "private"
  }
}

data "aws_subnet_ids" "v3_public_subnets" {
  vpc_id = "${data.aws_vpc.vpc_v3.id}"

  tags {
    subnet_type = "public"
  }
}


# vpc id, cidr etc, Name = name ..v1-shared
data "aws_vpc" "vpc_v1" {
  filter {
    name   = "tag:Name"
    values = ["v1-shared"]
  }
}

# subnet ids, subnet_type = public
data "aws_subnet_ids" "v1_private_subnets" {
  vpc_id = "${data.aws_vpc.vpc_v1.id}"

  tags {
    subnet_type = "private"
  }
}

data "aws_subnet_ids" "v1_public_subnets" {
  vpc_id = "${data.aws_vpc.vpc_v1.id}"

  tags {
    subnet_type = "public"
  }
}


# kms key
data "aws_kms_key" "v3_hydra_sandbox" {
  key_id = "alias/v3-hydra-sbx-kms"
}


# route53 private zone id - int
data "aws_route53_zone" "selected" {
  name         = "int.rwrd007.rewardcloud.net."
  private_zone = true
}

