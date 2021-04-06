module "dev_capture_olm_state" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-capture-state"

  cluster_type             = module.dev_cluster.platform.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = var.cluster_type == "ocp4" ? "openshift-operator-lifecycle-manager" : "olm"
  output_path              = "${path.cwd}/cluster-state/before"
}

module "dev_capture_operator_state" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-capture-state"

  cluster_type             = module.dev_cluster.platform.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  namespace                = var.cluster_type == "ocp4" ? "openshift-operators" : "operators"
  output_path              = "${path.cwd}/cluster-state/before"
}
