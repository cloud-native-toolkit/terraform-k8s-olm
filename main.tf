
locals {
  operator_namespace = var.cluster_type == "ocp4" ? "openshift-marketplace" : "olm"
  target_namespace   = var.cluster_type == "ocp4" ? "openshift-operators" : "operators"
}

data clis_check clis {
  clis = ["kubectl","jq"]
}

resource "null_resource" "deploy_operator_lifecycle_manager" {
  triggers = {
    KUBECONFIG      = var.cluster_config_file
    CLUSTER_TYPE    = var.cluster_type
    CLUSTER_VERSION = var.cluster_version
    OLM_VERSION     = var.olm_version
    BIN_DIR         = data.clis_check.clis.bin_dir
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-olm.sh ${self.triggers.OLM_VERSION}"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
      CLUSTER_TYPE    = self.triggers.CLUSTER_TYPE
      CLUSTER_VERSION = self.triggers.CLUSTER_VERSION
      BIN_DIR         = self.triggers.BIN_DIR
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/destroy-olm.sh"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
      CLUSTER_TYPE    = self.triggers.CLUSTER_TYPE
      CLUSTER_VERSION = self.triggers.CLUSTER_VERSION
      BIN_DIR         = self.triggers.BIN_DIR
    }
  }
}
