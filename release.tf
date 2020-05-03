locals {
  app_name = coalesce(var.app_name, var.name)
}

data "helm_repository" "uswitch" {
  name = "uswitch"
  url  = "https://uswitch.github.io/kiam-helm-charts/charts/"
}

resource "helm_release" "kiam" {
  depends_on    = [null_resource.apply_certificates]
  repository    = data.helm_repository.uswitch.metadata.0.name
  name          = local.app_name
  namespace     = "kube-system"
  chart         = "kiam"
  version       = "5.7.0"
  recreate_pods = true

  values = [
    templatefile("${path.module}/defaults.yaml", {
      server_replicas = var.server_replicas
    }),
    file("${var.helm_values_root}/values.yaml"),
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
    value = local.server_iam_role_arn
  }
}
