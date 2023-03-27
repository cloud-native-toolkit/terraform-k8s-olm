module "olm" {
  source = "../"

  cluster_config_file      = module.cluster.config_file_path
}
