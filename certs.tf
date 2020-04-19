locals {
  cert_resources_required = var.deploy_selfsigning_issuer || var.cert_manager_issuer_name != ""
  certificate_resources   = !local.cert_resources_required ? "" : templatefile("${path.module}/templates/certificates.yaml", {
    app_name                  = local.app_name
    deploy_selfsigning_issuer = var.deploy_selfsigning_issuer && var.cert_manager_issuer_name == ""
    issuer_kind               = var.cert_manager_issuer_kind
    issuer_name               = var.cert_manager_issuer_name
  })
}

resource "null_resource" "apply_certificates" {
  count = local.certificate_resources == "" ? 0 : 1

  provisioner "local-exec" {
    command = "echo \"${local.certificate_resources}\" | kubectl apply -f -"
  }
  
  triggers = {
    hash = md5(local.certificate_resources)
  }
}

resource "null_resource" "destroy_certificates" {
  count      = local.certificate_resources == "" ? 0 : 1
  depends_on = [null_resource.apply_certificates]

  provisioner "local-exec" {
    when    = destroy
    command = "echo \"${local.certificate_resources}\" | kubectl delete -f - --ignore-not-found"
  }
}
