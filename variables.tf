
variable "cluster_config_file" {
  type        = string
  description = "Cluster config file for Kubernetes cluster."
}

variable "olm_version" {
  type        = string
  description = "The version of olm that will be installed"
  default     = "v0.24.0"
}
