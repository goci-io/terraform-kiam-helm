locals {
  app_name = coalesce(var.app_name, var.name)
}

data "helm_repository" "uswitch" {
  name = "uswitch"
  url  = "https://uswitch.github.io/kiam-helm-charts/charts/"
}

resource "helm_release" "kiam" {
  depends_on = [null_resource.apply_certs]
  repository = data.helm_repository.uswitch.metadata.0.name
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
