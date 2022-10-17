module "dev_software_olm" {
  source = "./module"

  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_version          = ""
  cluster_type             = module.dev_cluster.cluster_type
}
