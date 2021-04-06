module "dev_cluster" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-ocp-vpc.git"

  resource_group_name     = var.resource_group_name
  region                  = var.region
  ibmcloud_api_key        = var.ibmcloud_api_key
  name                    = var.cluster_name
  worker_count            = 2
  name_prefix             = var.name_prefix
  exists                  = true
  cos_id                  = ""
  vpc_subnet_count        = 1
  vpc_name                = ""
}
