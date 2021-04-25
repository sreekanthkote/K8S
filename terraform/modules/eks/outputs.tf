
output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = "${module.eks.cluster_id}"
}

# Though documented, not yet supported
# output "cluster_arn" {
#   description = "The Amazon Resource Name (ARN) of the cluster."
#   value       = "${aws_eks_cluster.this.arn}"
# }

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = "${module.eks.cluster_certificate_authority_data}"
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = "${module.eks.cluster_endpoint}"
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = "${module.eks.cluster_version}"
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = "${module.eks.cluster_security_group_id}"
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = "${module.eks.config_map_aws_auth}"
}

output "kubeconfig" {
  description = "kubectl config file contents for this EKS cluster."
  value       = "${module.eks.kubeconfig}"
}

output "workers_asg_arns" {
  description = "IDs of the autoscaling groups containing workers."
  value       = "${module.eks.workers_asg_arns}"
}

output "workers_asg_names" {
  description = "Names of the autoscaling groups containing workers."
  value       = "${module.eks.workers_asg_names}"
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = "${module.eks.worker_security_group_id}"
}

output "worker_iam_role_name" {
  description = "default IAM role name for EKS worker groups"
  value       = "${module.eks.worker_iam_role_name}"
}

output "worker_iam_role_arn" {
  description = "default IAM role ARN for EKS worker groups"
  value       = "${module.eks.worker_iam_role_arn}"
}

output "kube2iam_worker_iam_role_name" {
  description = "kube2iam IAM role name for EKS worker groups"
  value       = "${aws_iam_role.workers.name}"
}

output "kube2iam_worker_iam_role_arn" {
  description = "kube2iam IAM role ARN for EKS worker groups"
  value       = "${aws_iam_role.workers.arn}"
}
