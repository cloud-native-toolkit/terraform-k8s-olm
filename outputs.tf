output "olm_namespace" {
  value       = data.external.olm_config.result.olm_namespace
  description = "Namespace where OLM is running. The value will be different between OCP 4.3 and IKS/OCP 3.11"
  depends_on  = [null_resource.deploy_operator_lifecycle_manager]
}

output "target_namespace" {
  value       = data.external.olm_config.result.target_namespace
  description = "Namespace where operatoes will be installed"
  depends_on  = [null_resource.deploy_operator_lifecycle_manager]
}

output "operator_namespace" {
  value       = data.external.olm_config.result.operator_namespace
  description = "Name space where catalog is running - and subscriptions need to be made"
  depends_on  = [null_resource.deploy_operator_lifecycle_manager]
}