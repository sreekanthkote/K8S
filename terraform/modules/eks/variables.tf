variable "name" {}
variable "cidr" {
  default = "0.0.0.0/0"
}
variable "cluster_version" {
  default = ""

}


variable "worker_group_count" {}


# EKS worker group blue
variable "wg_blue_instance_type" {}
variable "wg_blue_ami_id" {}
variable "wg_blue_spot_price" {}
variable "wg_blue_autoscaling_enabled" {}
variable "wg_blue_protect_from_scale_in" {}
variable "wg_blue_asg_desired_capacity" {}
variable "wg_blue_asg_max_size" {}
variable "wg_blue_asg_min_size" {}



# EKS worker group green
variable "wg_green_instance_type" {}
variable "wg_green_ami_id" {}
variable "wg_green_spot_price" {}
variable "wg_green_autoscaling_enabled" {}
variable "wg_green_protect_from_scale_in" {}
variable "wg_green_asg_desired_capacity" {}
variable "wg_green_asg_max_size" {}
variable "wg_green_asg_min_size" {}
