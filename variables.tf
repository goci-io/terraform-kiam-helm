
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

variable "assume_role_prefix" {
  type        = string
  default     = ""
  description = "Prefix of roles kiam will be able to assume. Defaults to roles within current account starting with <namespace>-pod-"
}

variable "cert_manager_issuer_name" {
  type        = string
  default     = ""
  description = "Name of an existing cert manager issuer. If its a ClusterIssuer you need to set cert_manager_issuer_kind to ClusterIssuer"
}

variable "cert_manager_issuer_kind" {
  type        = string
  default     = "ClusterIssuer"
  description = "Kind of the existing cert manager issuer to use. Can be Issuer or ClusterIssuer"
}

