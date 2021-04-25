# cluster_name                         = "${local.cluster_name}"
cluster_version                       = "1.11"

# vpc_id                               = "${data.terraform_remote_state.vpc.vpc_id}"
# subnets                              = ["${data.terraform_remote_state.vpc.private_subnets}"]
# worker_groups                        = "${local.worker_groups}"

# worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
# map_roles                            = "${var.map_roles}"
# map_users                            = "${var.map_users}"
# map_accounts                         = "${var.map_accounts}"
# tags                                 = "${local.tags}"


worker_group_count              = "2"

# worker group blue
wg_blue_instance_type           = "t3.large"
wg_blue_ami_id                  = "ami-0b469c0fef0445d29"
wg_blue_spot_price              = "0.05"
wg_blue_autoscaling_enabled     = true
wg_blue_protect_from_scale_in   = false
wg_blue_asg_desired_capacity    = 0
wg_blue_asg_max_size            = 0
wg_blue_asg_min_size            = 0


# worker group green
wg_green_instance_type          = "t3.large"
wg_green_ami_id                  = "ami-0b469c0fef0445d29"
wg_green_spot_price             = ""
wg_green_autoscaling_enabled    = true
wg_green_protect_from_scale_in  = false
wg_green_asg_desired_capacity   = 3
wg_green_asg_max_size           = 10
wg_green_asg_min_size           = 3
