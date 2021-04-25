terraform {
  backend "s3" {}
}

provider "kubernetes" {
  config_path              = "~/.kube/config"
  load_config_file        = true
}

# workaround...bug in provider. install_tiller = true does not work
# resource "null_resource" "helm_init" {
#   provisioner "local-exec" {
#     command = "helm init --service-account tiller "
#   }
# }


provider "helm" {
  # not working ?
  # install_tiller  = true
  # namespace       = "kube-system"
  # service_account = "tiller"
  # tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"


    kubernetes {
    }
}


variable "aws_region" {
  default = "eu-west-1"
}

