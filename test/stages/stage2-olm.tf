module "dev_software_olm" {
  source = "./module"

  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_version          = ""
  cluster_type             = module.dev_capture_olm_state.cluster_type == "" ? module.dev_capture_olm_state.cluster_type : module.dev_capture_operator_state.cluster_type
}
