#---------------------------
# Makefile
#---------------------------


SHELL := $(shell which bash) # set default shell
ENV = /usr/bin/env #  environment variables

TERRAFORM = docker run -it --rm -v $(CURDIR):/app/ -w /app/ hashicorp/terraform:light



.DEFAULT: help # Running Make will run the help target
.PHONY:  help all # All targets are accessible for user

help: ## Show Help
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
    sort | \
    awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'


#------
# vars
#------

# load environment variables
# include .env
# export

# ---------------------------------------------------------------------------------------------------------------------
# Python virtualenv
# ---------------------------------------------------------------------------------------------------------------------

setup: ## Set up python environment
	pipenv install

create_variables: setup ## Create terraform variables
	cd ./scripts/ && \
	pipenv run python setup-variables.py

# ---------------------------------------------------------------------------------------------------------------------
# Terraform environments
# ---------------------------------------------------------------------------------------------------------------------

sbx1: ## prod
	$(eval ENV = sbx1)



# ---------------------------------------------------------------------------------------------------------------------
# Terraform state backend
# ---------------------------------------------------------------------------------------------------------------------

state_bucket: ## Set up terraform state bucket and lock table
	cd ./terraform/backend/${ENV}/ && \
	terraform init && \
	terraform plan -lock=false -out=.terraform/terraform.tfplan && \
	terraform apply -auto-approve -lock=false -state=.terraform/terraform.tfstate

destroy_state_bucket: ## Destroy terraform state bucket and lock table
	cd ./terraform/backend/${ENV}/ && \
	terraform init && \
	terraform destroy -force -lock=false -state=.terraform/terraform.tfstate


# ---------------------------------------------------------------------------------------------------------------------
# Terraform module layers
# ---------------------------------------------------------------------------------------------------------------------

iam: ## iam layer
	$(eval LAYER = iam)

kms: ## kms layer
	$(eval LAYER = kms)

ecr: ## ecr layer
	$(eval LAYER = ecr)

eks: ## eks layer
	$(eval LAYER = eks)


k8s-tiller: ## k8s helm tiller
	$(eval LAYER = k8s-tiller)

k8s-kube2iam: ## k8s kube2iam
	$(eval LAYER = k8s-kube2iam)

k8s-autoscalers: ## k8s autoscalers
	$(eval LAYER = k8s-autoscalers)

k8s-externaldns: ## k8s externaldns
	$(eval LAYER = k8s-externaldns)

k8s-ingress: ## k8s ingress
	$(eval LAYER = k8s-ingress)


k8s-prometheus-operator: ## k8s metrics
	$(eval LAYER = k8s-prometheus-operator)


k8s-dashboard: ## k8s dashboard
	$(eval LAYER = k8s-dashboard)

ocs: ## rds postgres layer
	$(eval LAYER = ocs)

rds: ## rds postgres layer
	$(eval LAYER = rds)

rds-aurora: ## rds postgres aurora layer
	$(eval LAYER = rds-aurora)
# ---------------------------------------------------------------------------------------------------------------------
# Terragrunt commands
# ---------------------------------------------------------------------------------------------------------------------


plan:
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt plan-all --terragrunt-non-interactive --terragrunt-source-update

destroy-plan:
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt plan-all -destroy --terragrunt-non-interactive --terragrunt-source-update

apply:
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt apply-all --terragrunt-non-interactive --terragrunt-source-update

destroy: destroy-plan
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt destroy-all --terragrunt-non-interactive --terragrunt-source-update

output:
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt output-all --terragrunt-non-interactive --terragrunt-source-update

show:
		export ENV=${ENV} && export LAYER=${LAYER} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region}/${LAYER} && \
		terragrunt show --terragrunt-non-interactive --terragrunt-source-update

apply-all:
		export ENV=${ENV} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region} && \
		terragrunt apply-all --terragrunt-non-interactive --terragrunt-source-update

plan-all:
		export ENV=${ENV} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region} && \
		terragrunt plan-all --terragrunt-non-interactive --terragrunt-source-update

destroy-all:
		export ENV=${ENV} && cd ./terraform/live/${ENV}/${TF_VAR_aws_region} && \
		terragrunt destroy-all --terragrunt-non-interactive --terragrunt-source-update


clean: ## Clean up
	find . -type d -name '.terragrunt-cache' | xargs rm -r && \
	find . -type d -name '.terraform' | xargs rm -r
