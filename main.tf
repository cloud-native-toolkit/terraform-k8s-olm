
data clis_check clis {
  clis = ["kubectl","jq","operator-sdk"]
}

resource random_string uuid {
  length  = 16
  special = false
}

resource null_resource deploy_operator_lifecycle_manager {
  triggers = {
    KUBECONFIG  = var.cluster_config_file
    OLM_VERSION = var.olm_version
    UUID        = random_string.uuid.result
    BIN_DIR     = data.clis_check.clis.bin_dir
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-olm.sh '${self.triggers.OLM_VERSION}' '${self.triggers.UUID}'"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
      BIN_DIR         = self.triggers.BIN_DIR
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/destroy-olm.sh '${self.triggers.UUID}'"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
      BIN_DIR         = self.triggers.BIN_DIR
    }
  }
}

data external olm_config {
  depends_on = [null_resource.deploy_operator_lifecycle_manager]

  program = ["bash", "${path.module}/scripts/get-olm-config.sh"]

  query = {
    bin_dir = data.clis_check.clis.bin_dir
    kube_config = var.cluster_config_file
  }
}