module "ecr_lifecycle_rule_untagged_100_days_since_image_pushed" {

  source = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=master"

  tag_status = "untagged"
  count_type = "sinceImagePushed"
  count_number = "100"
}





module "ecr-hydra-sbx-jenkins" {
  source                      = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name                        = "hydra-sbx-jenkins"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  lifecycle_policy_rules    = ["${module.ecr_lifecycle_rule_untagged_100_days_since_image_pushed.policy_rule}" ]
  lifecycle_policy_rules_count = 1

  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-application-rms" {
  source                      = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name                        = "hydra-sbx-application-rms"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]

  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-feature-basiccampaign" {
  source                      = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name                        = "hydra-sbx-feature-basiccampaign"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-feature-offercreation" {
  source                      = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name                        = "hydra-sbx-feature-offercreation"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]

  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }
}

module "ecr-hydra-sbx-microservice-campaign" {
  source                      = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name                        = "hydra-sbx-microservice-campaign"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-microservice-offers" {
  source        = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name          = "hydra-sbx-microservice-offers"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  tags = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-microservice-partners" {
  source        = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name          = "hydra-sbx-microservice-partners"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]

  tags          = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-microservice-publishers" {
  source        = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name          = "hydra-sbx-microservice-publishers"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  tags          = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-microservice-collateral" {
  source        = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name          = "hydra-sbx-microservice-collateral"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ -admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx20190207180432502400000006"]


  tags          = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}

module "ecr-hydra-sbx-microservice-standardoffer" {
  source        = "git@github.com:xxxxxxxxxx/xxxxxxxxxx.git//?ref=v0.1"
  name          = "hydra-sbx-microservice-standardoffer"
  allowed_read_principals     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin-access",
                                "arn:aws:iam::xxxxxxxxxx:role/v3-hydra-sbx2019021701214396320000000f"]


  tags          = {
    terraform = "true"
    project_name = "hydra"
    environment = "sbx"
    created_by = "${local.created_by}"
  }

}
