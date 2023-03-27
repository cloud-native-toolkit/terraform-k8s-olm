# Operator Lifecycle Manager module

Installs Operator Lifecycle Manager (OLM) into a cluster using the operator-sdk install process. However, 
if the cluster already has OLM installed then the module just looks up the configuration values.

## Example usage

```hcl-terraform
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm.git"

  cluster_config_file = module.dev_cluster.config_file_path
}
```
