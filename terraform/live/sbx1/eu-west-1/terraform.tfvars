# -------------------------
# Terragrunt state config
#
# This is a configuration for Terragrunt to handle the backend for all lower level layers.
# If a resource does not have a unique remote_state configuration within its tfvars; it will inherit these.
# --------------------------

terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "${get_env("TF_VAR_name", "not-set")}-tfstate-${get_env("TF_VAR_aws_region", "not-set")}-rwrd-uk"
      key            = "${path_relative_to_include()}.tfstate"
      region         = "${get_env("TF_VAR_aws_region", "eu-west-1")}"
      dynamodb_table = "${get_env("TF_VAR_name", "not-set")}-tfstate-${get_env("TF_VAR_aws_region", "not-set")}-rwrd-uk"
    }

  }
}

