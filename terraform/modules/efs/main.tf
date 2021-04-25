
locals {
  enabled  = "${var.enabled == "true"}"
  dns_name = "${join("", aws_efs_file_system.default.*.id)}.efs.${var.aws_region}.amazonaws.com"
}


resource "aws_efs_file_system" "default" {
  count                           = "${local.enabled ? 1 : 0}"
  encrypted                       = "${var.encrypted}"
  performance_mode                = "${var.performance_mode}"
  provisioned_throughput_in_mibps = "${var.provisioned_throughput_in_mibps}"
  throughput_mode                 = "${var.throughput_mode}"
  tags                            = "${var.tags}"
}



resource "aws_efs_mount_target" "default" {
  count           = "${local.enabled && length(data.aws_availability_zones.available.names) > 0 ? length(data.aws_availability_zones.available.names) : 0}"
  file_system_id  = "${join("", aws_efs_file_system.default.*.id)}"
  ip_address      = "${var.mount_target_ip_address}"
  subnet_id       = "${element(data.aws_subnet_ids.private_subnets.ids, count.index)}"
  security_groups = ["${join("", aws_security_group.default.*.id)}"]

}

resource "aws_security_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "v3-efs"
  description = "EFS"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049"                     # NFS
    to_port         = "2049"
    protocol        = "tcp"
    # security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${module.label.tags}"
}


resource "aws_route53_record" "efs" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "v3-efs"
  type    = "CNAME"
  ttl     = "30"
  records = ["${local.dns_name}"]
}

