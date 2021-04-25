


resource "aws_security_group" "rds" {
  name        = "${var.identifier}-sg"
  description = "RDS postgres security group"
  vpc_id      = "${data.aws_vpc.vpc_v3.id}"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.vpc_v1.cidr_block}","${data.aws_vpc.vpc_v3.cidr_block}"]
  }

  tags {
    Name          = "${var.identifier}-sg"
    terraform     = "true"
    environment   = "sbx"
    project_name  = "hydra"
  }
}


#---------------------------------------------------
# dev database
#---------------------------------------------------

# Generate a random admin password
resource "random_string" "password" {
    length  = 16
    upper   = true
    lower   = true
    number  = true
    special = false

    keepers = {
        name = "${var.identifier}"
    }
}


resource "aws_ssm_parameter" "secret" {
  name        = "/rwrd007/v3-shared/${var.identifier}/root_password"
  description = "root postgres database password"
  type        = "SecureString"
  value       = "${random_string.password.result}"
  key_id      = "${data.aws_kms_key.v3_hydra_sandbox.id}"

  tags = {
    terraform     = "true"
    environment   = "sbx"
    project_name  = "hydra"
  }
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier          = "${var.identifier}"

  engine              = "${var.engine}"
  engine_version      = "${var.engine_version}"
  instance_class      = "${var.instance_class}"
  allocated_storage   = "${var.allocated_storage}"
  storage_encrypted   = "${var.storage_encrypted}"
  kms_key_id          = "${data.aws_kms_key.v3_hydra_sandbox.arn}"
  port                = "${var.port}"

 # master username/password for db instance
  username            = "${var.username}"
  password            = "${random_string.password.result}"


  publicly_accessible                 = "${var.publicly_accessible}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  vpc_security_group_ids              = ["${aws_security_group.rds.id}"]

  multi_az                  = "${var.multi_az}"

  # DB subnet group
  subnet_ids                = "${data.aws_subnet_ids.v3_private_subnets.ids}"

  # DB parameter group
  family                    = "${var.family}"

  # DB option group
  major_engine_version      = "${var.major_engine_version}"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.final_snapshot_identifier}"
  copy_tags_to_snapshot     = "${var.copy_tags_to_snapshot}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"

  # Database Deletion Protection
  deletion_protection       = "${var.deletion_protection}"



  # Backups/Patching
  maintenance_window        = "${var.maintenance_window}"
  backup_window             = "${var.backup_window}"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval       = "${var.monitoring_interval}"
  monitoring_role_name      = "${var.monitoring_role_name}"
  create_monitoring_role    = "${var.create_monitoring_role}"


  tags                      = "${var.tags}"
}



resource "aws_route53_record" "rds" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.identifier}"
  type    = "CNAME"
  ttl     = "30"
  records = ["${module.db.this_db_instance_address}"]
}

#---------------------------------------------------
# demo database
#---------------------------------------------------


# Generate a random admin password
resource "random_string" "password" {
    length  = 16
    upper   = true
    lower   = true
    number  = true
    special = false

    keepers = {
        name = "${var.identifier}"
    }
}


resource "aws_ssm_parameter" "secret" {
  name        = "/rwrd007/v3-shared/${var.identifier}/hydra/demo/postgres/root_password"
  description = "demo env - root postgres database password"
  type        = "SecureString"
  value       = "${random_string.password.result}"
  key_id      = "${data.aws_kms_key.v3_hydra_sandbox.id}"

  tags = {
    terraform     = "true"
    environment   = "sbx"
    project_name  = "hydra"
  }
}


module "db-demo" {
  source = "terraform-aws-modules/rds/aws"

  identifier          = "${var.identifier}-demo"

  engine              = "${var.engine}"
  engine_version      = "${var.engine_version}"
  instance_class      = "${var.instance_class}"
  allocated_storage   = "${var.allocated_storage}"
  storage_encrypted   = "${var.storage_encrypted}"
  kms_key_id          = "${data.aws_kms_key.v3_hydra_sandbox.arn}"
  port                = "${var.port}"

 # master username/password for db instance
  username            = "${var.username}"
  password            = "${random_string.password.result}"


  publicly_accessible                 = "${var.publicly_accessible}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  vpc_security_group_ids              = ["${aws_security_group.rds.id}"]

  multi_az                  = "${var.multi_az}"

  # DB subnet group
  subnet_ids                = "${data.aws_subnet_ids.v3_private_subnets.ids}"

  # DB parameter group
  family                    = "${var.family}"

  # DB option group
  major_engine_version      = "${var.major_engine_version}"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.final_snapshot_identifier}"
  copy_tags_to_snapshot     = "${var.copy_tags_to_snapshot}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"

  # Database Deletion Protection
  deletion_protection       = "${var.deletion_protection}"



  # Backups/Patching
  maintenance_window        = "${var.maintenance_window}"
  backup_window             = "${var.backup_window}"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval       = "${var.monitoring_interval}"
  monitoring_role_name      = "${var.monitoring_role_name}"
  create_monitoring_role    = "${var.create_monitoring_role}"


tags = {
    terraform     = "true"
    project_name  = "hydra"
    component     = "db"
    environment   = "demo"
}

}



resource "aws_route53_record" "rds" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.identifier}-demo"
  type    = "CNAME"
  ttl     = "30"
  records = ["${module.db.this_db_instance_address}"]
}


#---------------------------------------------------
# mmurray database
#---------------------------------------------------
