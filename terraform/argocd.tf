# Deploy ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.6"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  timeout    = 600

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Wait for ArgoCD to be ready
resource "time_sleep" "argocd_wait" {
  depends_on      = [helm_release.argocd]
  create_duration = "60s"
}

# Create ArgoCD application for infrastructure components
resource "kubectl_manifest" "argocd_infra_app" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-infrastructure"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-infrastructure"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/stackai/stackai-byoc-poc"
        targetRevision = "HEAD"
        path           = "helm/infra"
        helm = {
          valueFiles = ["${path.module}/values/*.yaml"]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.stackai_infra.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true",
          "PrunePropagationPolicy=foreground",
          "PruneLast=true"
        ]
      }
    }
  })
}

# Create ArgoCD application for application components
resource "kubectl_manifest" "argocd_apps" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-applications"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-applications"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/stackai/stackai-byoc-poc"
        targetRevision = "HEAD"
        path           = "helm/app"
        helm = {
          valueFiles = ["${path.module}/values/*.yaml"]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.stackai_processing.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true",
          "PrunePropagationPolicy=foreground",
          "PruneLast=true"
        ]
      }
    }
  })
}
