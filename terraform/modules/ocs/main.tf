
//--------------------------
// S3 bucket
//--------------------------

# create bucket for S3 origin
resource "aws_s3_bucket" "dev" {
  bucket          = "collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"
   acl            = "private"
   force_destroy  = "${var.force_destroy}"
   region         = "${data.aws_region.current.name}"

   versioning {
    enabled = true
  }

   tags = {
      "terraform"    =  "true"
      "project_name" =  "hydra"
      "environment"  =  "dev"
      "component"    =  "object_collateral_store"
   }

}

# bucket policy to allow anonymous users readonly access to objects
resource "aws_s3_bucket_policy" "dev" {
  bucket = "${aws_s3_bucket.dev.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk/*"]
    }
  ]
}
POLICY
}





# k8s role for object collateral store microservice
resource "aws_iam_role" "k8s-s3-collateral-dev" {
  name                  = "k8s-${var.name}-s3-collateral-dev"
  description           = "S3 collateral-dev role for k8s cluster ${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.s3_collateral_assume_role_policy.json}"
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "k8s-s3-collateral-dev" {
  policy_arn = "${aws_iam_policy.k8s-s3-collateral-dev.arn}"
  role       = "${aws_iam_role.k8s-s3-collateral-dev.name}"
}

resource "aws_iam_policy" "k8s-s3-collateral-dev" {
  name        = "k8s-${var.name}-s3-collateral-dev"
  description = "s3-collateral-dev policy for k8s cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.s3_collateral_dev.json}"
}




data "aws_iam_policy_document" "s3_collateral_dev" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:PutObject",
               "s3:GetObject"
              ]
    resources = ["arn:aws:s3:::collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk/*"]
  }
}




resource "aws_cloudfront_origin_access_identity" "dev" {
  comment = "object collateral store - dev "
}

# locals {
#   s3_origin_id = "collateral-${var.env}-${local.account_alias}-ew1-rwrd-uk"
# }


resource "aws_cloudfront_distribution" "dev" {
  origin {
    domain_name = "${aws_s3_bucket.dev.bucket_regional_domain_name}"
    origin_id   = "collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.dev.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "collateral object store - dev"


  # logging_config {
  #   include_cookies = false
  #   bucket          = ""
  #   prefix          = ""
  # }

  aliases = ["rms-collateral.dev.rwrd007.rewardcloud.net"]

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "collateral-dev-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    "terraform"   =  "true"
    "project_name" =  "hydra"
    "environment"  =  "dev"
    "component"    =  "object_collateral_store"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


resource "aws_route53_record" "dev" {
  zone_id = "${data.aws_route53_zone.dev.zone_id}"
  name    = "rms-collateral"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_cloudfront_distribution.dev.domain_name}"]
}















#-----------------------------------------------------------------------------------------------------------


resource "aws_s3_bucket" "demo" {
  bucket          = "collateral-demo-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"
   acl            = "private"
   force_destroy  = "${var.force_destroy}"
   region         = "${data.aws_region.current.name}"

   versioning {
    enabled = true
  }

   tags = {
      "terraform"    =  "true"
      "project_name" =  "hydra"
      "environment"  =  "demo"
      "component"    =  "object_collateral_store"
   }

}

resource "aws_iam_role" "k8s-s3-collateral-demo" {
  name                  = "k8s-${var.name}-s3-collateral-demo"
  description           = "S3 collateral-dev role for k8s cluster ${var.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.s3_collateral_assume_role_policy.json}"
  force_detach_policies = true
}


resource "aws_iam_role_policy_attachment" "k8s-s3-collateral-demo" {
  policy_arn = "${aws_iam_policy.k8s-s3-collateral-demo.arn}"
  role       = "${aws_iam_role.k8s-s3-collateral-demo.name}"
}

resource "aws_iam_policy" "k8s-s3-collateral-demo" {
  name        = "k8s-${var.name}-s3-collateral-demo"
  description = "s3-collateral-demo policy for k8s cluster ${var.name}"
  policy      = "${data.aws_iam_policy_document.s3_collateral_demo.json}"
}



data "aws_iam_policy_document" "s3_collateral_assume_role_policy" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.terraform_remote_state.eks.kube2iam_worker_iam_role_arn}"]
    }
  }

}


data "aws_iam_policy_document" "s3_collateral_demo" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::collateral-demo-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:PutObject",
               "s3:GetObject"
              ]
    resources = ["arn:aws:s3:::collateral-demo-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk/*"]
  }
}




resource "aws_cloudfront_origin_access_identity" "demo" {
  comment = "object collateral store - demo "
}

# locals {
#   s3_origin_id = "collateral-${var.env}-${local.account_alias}-ew1-rwrd-uk"
# }


resource "aws_cloudfront_distribution" "demo" {
  origin {
    domain_name = "${aws_s3_bucket.demo.bucket_regional_domain_name}"
    origin_id   = "collateral-demo-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.demo.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "collateral object store - demo"


  # logging_config {
  #   include_cookies = false
  #   bucket          = ""
  #   prefix          = ""
  # }

  aliases = ["rms-collateral.demo.rwrd007.rewardcloud.net"]

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "collateral-demo-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    "terraform"   =  "true"
    "project_name" =  "hydra"
    "environment"  =  "demo"
    "component"    =  "object_collateral_store"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


# resource "aws_route53_record" "demo" {
#   zone_id = "${data.aws_route53_zone.demo.zone_id}"
#   name    = "rms-collateral"
#   type    = "CNAME"
#   ttl     = "30"
#   records = ["${aws_cloudfront_distribution.demo.domain_name}"]
# }
































resource "aws_s3_bucket" "mmurray" {
  bucket          = "collateral-mmurray-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"
   acl            = "private"
   force_destroy  = "${var.force_destroy}"
   region         = "${data.aws_region.current.name}"

   versioning {
    enabled = true
  }

   tags = {
      "terraform"    =  "true"
      "project_name" =  "hydra"
      "environment"  =  "mmurray"
      "component"    =  "object_collateral_store"
   }

}

resource "aws_s3_bucket" "ekrawczk" {
  bucket          = "collateral-ekrawczk-${data.aws_iam_account_alias.current.account_alias}-eu-west-1-rwrd-uk"
   acl            = "private"
   force_destroy  = "${var.force_destroy}"
   region         = "${data.aws_region.current.name}"

   versioning {
    enabled = true
  }

   tags = {
      "terraform"    =  "true"
      "project_name" =  "hydra"
      "environment"  =  "ekrawczk"
      "component"    =  "object_collateral_store"
   }

}




# # collateral-sts-user-policy
# data "template_file" "collateral-sts-user-policy" {
#   template = "${file("${path.module}/iam_policies/rwrd-collateral-sts-user-policy.json.tpl")}"

#   vars {
#     aws_account_id  = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env             = "${var.env}"
#   }
# }

# # collateral-s3-trust-policy
# data "template_file" "collateral-s3-trust-policy" {
#   template = "${file("${path.module}/iam_policies/rwrd-collateral-s3-trust-policy.json.tpl")}"

#   vars {
#     aws_account_id  = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env             = "${var.env}"
#   }
# }

# # collateral-s3-policy
# data "template_file" "collateral-s3-policy" {
#   template = "${file("${path.module}/iam_policies/rwrd-collateral-s3-policy.json.tpl")}"

#   vars {
#     aws_account_id  = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env             = "${var.env}"
#   }
# }






# # collateral-s3-admin-trust-policy
# data "template_file" "collateral-s3-admin-trust-policy" {
#   template = "${file("${path.module}/iam_policies/rwrd-collateral-s3-admin-trust-policy.json.tpl")}"

#   vars {
#     aws_account_id  = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env             = "${var.env}"
#   }
# }

# # collateral-s3-admin-policy
# data "template_file" "collateral-s3-admin-policy" {
#   template = "${file("${path.module}/iam_policies/rwrd-collateral-s3-admin-policy.json.tpl")}"

#   vars {
#     aws_account_id  = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env             = "${var.env}"
#   }
# }

# # collateral-s3-bucket-policy
# data "template_file" "collateral-s3-bucket-policy" {
#   template = "${file("${path.module}/iam_policies/collateral-s3-bucket-policy.json.tpl")}"

#   vars {
#     aws_account_id    = "${local.account_id}"
#     aws_account_alias = "${local.account_alias}"
#     env               = "${var.env}"
#     origin_access_identity = "${aws_cloudfront_origin_access_identity.default.iam_arn}"
#   }
# }





# //--------------------------
# //  IAM users
# //--------------------------

# resource "aws_iam_user" "sts" {
#   name = "rwrd-collateral-${var.env}-sts"
#   path = "/"
#   force_destroy = "${var.user_force_destroy}"
# }

# resource "aws_iam_user_policy" "sts" {
#   name    = "rwrd-collateral-${var.env}-sts"
#   user    = "${aws_iam_user.sts.name}"
#   policy  = "${data.template_file.collateral-sts-user-policy.rendered}"
# }

# resource "aws_iam_access_key" "user" {
#   user  = "${aws_iam_user.sts.name}"
# }


//--------------------------


# //--------------------------
# // S3 bucket
# //--------------------------

# # create bucket for S3 origin
# resource "aws_s3_bucket" "b" {
#   bucket          = "collateral-${var.env}-${local.account_alias}-ew1-rwrd-uk"
#    acl            = "public-read"
#    force_destroy  = "${var.origin_force_destroy}"
#    region         = "${data.aws_region.current.name}"

#    versioning {
#     enabled = true
#   }

#    tags = {
#       "terraform"    =  "true"
#       "project_id"   =  "${var.project_id}"
#       "project_name" =  "${var.project_name}"
#       "environment"  =  "${var.env}"
#       "component"    =  "${var.project_component}"
#    }

# }


# resource "aws_s3_bucket_policy" "bp" {
#   bucket = "${aws_s3_bucket.b.id}"
#   policy = "${data.template_file.collateral-s3-bucket-policy.rendered}"
# }



# //--------------------------
# // Cloudfront
# //--------------------------


# resource "aws_cloudfront_origin_access_identity" "default" {
#   comment = "object collateral store"
# }

# locals {
#   s3_origin_id = "collateral-${var.env}-${local.account_alias}-ew1-rwrd-uk"
# }


# resource "aws_cloudfront_distribution" "default" {
#   origin {
#     domain_name = "${aws_s3_bucket.b.bucket_regional_domain_name}"
#     origin_id   = "${local.s3_origin_id}"

#     s3_origin_config {
#       origin_access_identity = "${aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path}"
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = false
#   comment             = "collateral object store - ${var.env}"


#   # logging_config {
#   #   include_cookies = false
#   #   bucket          = ""
#   #   prefix          = ""
#   # }

#   # aliases = ["mysite.example.com", "yoursite.example.com"]

#   default_cache_behavior {
#     allowed_methods  = [ "GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "${local.s3_origin_id}"

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "allow-all"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }


#   price_class = "PriceClass_All"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags {
#     "terraform"   =  "true"
#     "project_id"   =  "${var.project_id}"
#     "project_name" =  "${var.project_name}"
#     "environment"  =  "${var.env}"
#     "component"    =  "${var.project_component}"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
