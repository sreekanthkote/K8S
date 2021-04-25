terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  default = "eu-west-1"
}


provider "kubernetes" {
  version                   = ">= 1.4.0"
  config_path               = "~/.kube/config"
  load_config_file          = true
}



resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true

}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "tiller"

    api_group = ""
    namespace = "kube-system"
  }
}

# Not installing tiller correctly?
provider "helm" {
  version = "~> 0.7"

  debug           = true
  install_tiller  = true
  insecure        = true
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"

  kubernetes {
    config_path = "~/.kube/config"
  }
}

# workaround...bug in provider. install_tiller = true does not work
resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    when = "create"
    command = "helm init --service-account tiller "
  }
}

# helm reset...also not working...grrr
# manually uninstall service, deployment, etc
resource "null_resource" "helm_reset" {
  provisioner "local-exec" {
    when = "destroy"
    command = "helm reset --force"
  }
  depends_on = [ "kubernetes_cluster_role_binding.tiller", "kubernetes_service_account.tiller"]
}
