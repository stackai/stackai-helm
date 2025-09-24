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

# Create ArgoCD application for MongoDB
resource "kubectl_manifest" "argocd_mongodb" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-mongodb"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-mongodb"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/mongo"
        chart          = "stackai-mongodb"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/mongodb-dev.yaml"]
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

# Create ArgoCD application for Redis
resource "kubectl_manifest" "argocd_redis" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-redis"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-redis"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/redis"
        chart          = "stackai-redis"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/redis-dev.yaml"]
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

# Create ArgoCD application for PostgreSQL
resource "kubectl_manifest" "argocd_postgres" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-postgres"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-postgres"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/postgres"
        chart          = "stackai-postgres"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/postgres-dev.yaml"]
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

# Create ArgoCD application for Weaviate
resource "kubectl_manifest" "argocd_weaviate" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-weaviate"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-weaviate"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/weaviate"
        chart          = "stackai-weaviate"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/weaviate-dev.yaml"]
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

# Create ArgoCD application for Supabase
resource "kubectl_manifest" "argocd_supabase" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-supabase"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-supabase"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/supabase"
        chart          = "stackai-supabase"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/supabase-dev.yaml"]
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

# Create ArgoCD application for Nginx Ingress
resource "kubectl_manifest" "argocd_nginx" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-nginx-ingress"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-nginx-ingress"
        "app.kubernetes.io/component" = "infrastructure"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/infra/nginx"
        chart          = "stackai-nginx-ingress"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/nginx-dev.yaml"]
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


# Create ArgoCD application for Temporal
resource "kubectl_manifest" "argocd_temporal" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-temporal"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-temporal"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/temporal"
        chart          = "stackai-temporal"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/temporal-dev.yaml"]
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

# Create ArgoCD application for Unstructured
resource "kubectl_manifest" "argocd_unstructured" {
  depends_on = [time_sleep.argocd_wait]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-unstructured"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-unstructured"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/unstructured"
        chart          = "stackai-unstructured"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/unstructured-dev.yaml"]
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

# Create ArgoCD application for Stackend - THIRD in application deployment order
resource "kubectl_manifest" "argocd_stackend" {
  depends_on = [
    time_sleep.argocd_wait,
    kubectl_manifest.argocd_repl
  ]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-stackend"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-stackend"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/stackend"
        chart          = "stackai-stackend"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/stakend-values.yaml"]
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

# Create ArgoCD application for Stackweb - FOURTH in application deployment order
resource "kubectl_manifest" "argocd_stackweb" {
  depends_on = [
    time_sleep.argocd_wait,
    kubectl_manifest.argocd_stackend
  ]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-stackweb"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-stackweb"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/stackweb"
        chart          = "stackai-stackweb"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/stakweb-values.yaml"]
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

# Create ArgoCD application for Celery - FIRST in application deployment order
resource "kubectl_manifest" "argocd_celery" {
  depends_on = [
    time_sleep.argocd_wait,
    kubectl_manifest.argocd_nginx,
    kubectl_manifest.argocd_supabase,
    kubectl_manifest.argocd_mongodb,
    kubectl_manifest.argocd_redis,
    kubectl_manifest.argocd_postgres,
    kubectl_manifest.argocd_weaviate,
    kubectl_manifest.argocd_temporal,
    kubectl_manifest.argocd_unstructured
  ]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-celery"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-celery"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/celery"
        chart          = "stackai-celery"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/celery-values.yaml"]
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

# Create ArgoCD application for Repl - SECOND in application deployment order
resource "kubectl_manifest" "argocd_repl" {
  depends_on = [
    time_sleep.argocd_wait,
    kubectl_manifest.argocd_celery
  ]

  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "stackai-repl"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "stackai-repl"
        "app.kubernetes.io/component" = "applications"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "file://${path.module}/../helm/app/repl"
        chart          = "stackai-repl"
        targetRevision = "HEAD"
        helm = {
          valueFiles = ["${path.module}/values/repl-values.yaml"]
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
