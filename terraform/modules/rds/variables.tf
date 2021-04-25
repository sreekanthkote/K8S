variable "identifier" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "storage_encrypted" {}
variable "kms_key_id" {
  default=""
}
variable "port" {}
variable "username" {}
variable "password" {
  default=""
}
variable "publicly_accessible" {
  default = false
}
variable "iam_database_authentication_enabled" {}
variable "vpc_security_group_ids" {
  default = []
}
variable "multi_az" {}
variable "subnet_ids" {
  default = {}
}
variable "family" {}
variable "major_engine_version" {}
variable "final_snapshot_identifier" {}
variable "copy_tags_to_snapshot" {}
variable "skip_final_snapshot" {}
variable "deletion_protection" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "monitoring_interval" {}
variable "monitoring_role_name" {}
variable "create_monitoring_role" {}
variable "tags" {
  default={}
  type = "map"
}
