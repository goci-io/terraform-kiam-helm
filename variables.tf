
variable "namespace" {
  type        = string
  description = "Organization or company namespace prefix"
}

variable "stage" {
  default     = ""
  description = "The stage the deployment covers"
}

variable "environment" {
  default     = ""
  description = "The environment the deployment covers"
}

variable "region" {
  type        = string
  description = "Custom region name the deployment is for"
}

variable "name" {
  type        = string
  default     = "kiam"
  description = "Name of this deployment and related resources"
}

variable "app_name" {
  type        = string
  default     = ""
  description = "Overwrite for the helm deployment name"
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `eu1`)"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "server_replicas" {
  type        = number
  default     = 3
  description = "Number of replicas for the kiam-server deployment"
}

variable "cluster_tld" {
  type        = string
  default     = ""
  description = "The TLD of your cluster domain to automatically guess the master role arn"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "The AWS Account ID. Required if masters_role_arn is not set. Defaults to current AWS account ID"
}

variable "masters_role_arn" {
  type        = string
  default     = ""
  description = "Instance role of masters in your kubernetes cluster. Defaults to masters.<stage>.<region>.<namespace>.<cluster_tld>"
}

variable "assume_roles" {
  type        = list(string)
  default     = []
  description = "Role ARNs to allow Kiam to assume"
}

variable "iam_role_name_override" {
  type        = string
  default     = ""
  description = "Overrides the IAM role name to use for cert-manager DNS challanges with Route53"
}

variable "server_iam_role_arn" {
  type        = string
  default     = ""
  description = "Existing IAM role to use. We will only attach a policy which will allow to assume prefixed roles"
}

variable "cert_manager_issuer_name" {
  type        = string
  default     = ""
  description = "Name of an existing cert manager issuer. If its a ClusterIssuer you need to set cert_manager_issuer_kind to ClusterIssuer"
}

variable "cert_manager_issuer_kind" {
  type        = string
  default     = "Issuer"
  description = "Kind of the existing cert manager issuer to use. Can be Issuer or ClusterIssuer"
}

variable "deploy_selfsigning_issuer" {
  type        = bool
  default     = false
  description = "If there is no certificate issuer available we can deploy a selfsigning issuer to issue kiam certificates"
}

variable "helm_values_root" {
  type        = string
  default     = "."
  description = "Path to the directory containing values.yaml for helm to overwrite any defaults"
}
