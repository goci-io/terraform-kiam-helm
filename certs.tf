locals {
  certificate_resources = var.cert_manager_issuer_name == "" ? "" : templatefile("${path.module}/templates/certificates.yaml", {
    app_name    = local.app_name
    issuer_name = var.cert_manager_issuer_name
    issuer_kind = var.cert_manager_issuer_kind
  })
}

resource "null_resource" "apply_certificates" {
  count = local.certificate_resources == "" ? 0 : 1

  provisioner "local-exec" {
    command = "echo \"${local.certificate_resources}\" | kubectl apply -f -"
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
