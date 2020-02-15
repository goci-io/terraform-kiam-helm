locals {
  app_name = coalesce(var.app_name, var.name)

  certificate_resources = var.cert_manager_issuer_name == "" ? "" : templatefile("${path.module}/templates/certificates.yaml", {
    app_name           = local.app_name
    issuer_name        = var.cert_manager_issuer_name
    issuer_kind        = var.cert_manager_issuer_kind
  })
}

data "helm_repository" "uswitch" {
  name = "uswitch"
  url  = "https://uswitch.github.io/kiam-helm-charts/charts/"
}

resource "helm_release" "kiam" {
  depends_on = [null_resource.apply_certs]
  repository = helm_repository.uswitch.name
  name       = local.app_name
  chart      = "stable/kiam"
  namespace  = "kube-system"
  version    = "5.7.0"

  values = [
    file("${path.module}/defaults.yaml"),
    file("${path.module}/values.yaml"),
  ]

  set {
    name  = "agent.tlsSecret"
    value = format("%s-agent-tls", local.app_name)
  }

  set {
    name  = "server.tlsSecret"
    value = format("%s-server-tls", local.app_name)
  }

  set {
    name  = "server.assumeRoleArn"
    value = aws_iam_role.kiam_server.arn
  }
}

resource "null_resource" "apply_certs" {
  count = local.certificate_resources == "" ? 0 : 1

  provisioner "local-exec" {
    command = "echo \"${local.certificate_resources}\" | kubectl apply -f -"
  }
}

resource "null_resource" "destroy_certificates" {
  count      = local.certificate_resources == "" ? 0 : 1
  depends_on = [null_resource.apply_certificates]

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo \"${local.certificate_resources}\" | kubectl delete -f - --ignore-not-found"
  }
}
