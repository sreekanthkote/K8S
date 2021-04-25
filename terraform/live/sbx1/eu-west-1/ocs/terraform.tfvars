
# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terragrunt = {
  dependencies {
      paths = []
    }

  include {
    path = "${find_in_parent_folders()}"
  }


  terraform {

    source = "../../../../modules/ocs"

    extra_arguments "global_vars" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = [
        "-var", "name=${get_env("TF_VAR_name", "not-set")}"
      ]
      required_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("ocs.tfvars")}"
         ]
    }
  }

}

