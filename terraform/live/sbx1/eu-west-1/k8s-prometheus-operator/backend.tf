terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  default = "eu-west-1"
}

