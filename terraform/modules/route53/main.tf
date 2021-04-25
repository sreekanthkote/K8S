resource "aws_acm_certificate" "dev" {
  domain_name       = "*.dev.rwrd007.rewardcloud.net"
  validation_method = "DNS"

  tags = {
    "terraform"   =  "true"
    "project_name" =  "hydra"
    "environment"  =  "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}
