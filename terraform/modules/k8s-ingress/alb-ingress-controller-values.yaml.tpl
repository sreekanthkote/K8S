# Default values for aws-alb-ingress-controller.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

## Resources created by the ALB Ingress controller will be prefixed with this string
## Required
clusterName: "${cluster_name}"

## AWS region of k8s cluster, required if ec2metadata is unavailable from controller pod
## Required if autoDiscoverAwsRegion != true
awsRegion: "eu-west-1"

## Auto Discover awsRegion from ec2metadata, set this to true and omit awsRegion when ec2metadata is available.
autoDiscoverAwsRegion: "${auto_discover_aws_region}"

## VPC ID of k8s cluster, required if ec2metadata is unavailable from controller pod
## Required if autoDiscoverAwsVpcID != true
awsVpcID: "vpc-xxx"

## Auto Discover awsVpcID from ec2metadata, set this to true and omit awsVpcID: " when ec2metadata is available.
autoDiscoverAwsVpcID: "${auto_discover_aws_vpc_id}"

scope:
  ## If provided, the ALB ingress controller will only act on Ingress resources annotated with this class
  ## Ref: https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/docs/configuration.md#limiting-ingress-class
  ingressClass: alb

  ## If true, the ALB ingress controller will only act on Ingress resources in a single namespace
  ## Default: false; watch all namespaces
  singleNamespace: false

  ## If scope.singleNamespace=true, the ALB ingress controller will only act on Ingress resources in this namespace
  ## Ref: https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/docs/configuration.md#limiting-namespaces
  ## Default: namespace of the ALB ingress controller
  watchNamespace: ""

extraArgs: {}

extraEnv: {}
  # AWS_ACCESS_KEY_ID: ""
  # AWS_SECRET_ACCESS_KEY: ""

podAnnotations: {"iam.amazonaws.com/role": "k8s-v3-hydra-sbx-alb-ingress-controller" }
  # iam.amazonaws.com/role: alb-ingress-controller

podLabels: {}

# whether configure readinessProbe on controller pod
enableReadinessProbe: false

# How often (in seconds) to check controller readiness
readinessProbeInterval: 60

# How long to wait before timeout (in seconds) when checking controller readiness
readinessProbeTimeout: 3

# How long to wait (in seconds) before checking the readiness probe
readinessProbeInitialDelay: 30

# whether configure livenessProbe on controller pod
enableLivenessProbe: false

# How long to wait (in seconds) before checking the liveness probe
livenessProbeInitialDelay: 30

rbac:
  ## If true, create & use RBAC resources
  ##
  create: true
  serviceAccountName: default

image:
  repository: docker.io/amazon/aws-alb-ingress-controller
  tag: "v1.0.1"
  pullPolicy: IfNotPresent

replicaCount: 1
nameOverride: ""
fullnameOverride: ""

resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #  cpu: 100m
  #  memory: 128Mi
  # requests:
  #  cpu: 100m
  #  memory: 128Mi

nodeSelector: {}
  # node-role.kubernetes.io/node: "true"
  # tier: cs

tolerations: []
  #  - key: "node-role.kubernetes.io/master"
  #    effect: NoSchedule

affinity: {}
