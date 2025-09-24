# Deploy Official Nginx Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  namespace  = kubernetes_namespace.stackai_infra.metadata[0].name

  values = [
    file("${path.module}/values/nginx-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_infra]
}

# Apply the generated ingress configuration
resource "kubectl_manifest" "stackai_ingress" {
  depends_on = [helm_release.nginx_ingress]
  # Use the generated ingress configuration if it exists, otherwise use template
  yaml_body = fileexists("${path.module}/ingress-config.yaml") ? file("${path.module}/ingress-config.yaml") : file("${path.module}/ingress-template.yaml")
}

# Deploy MongoDB
resource "helm_release" "mongodb" {
  name      = "mongodb"
  chart     = "${path.module}/../helm/infra/mongo"
  namespace = kubernetes_namespace.stackai_data.metadata[0].name

  values = [
    file("${path.module}/values/mongodb-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_data]
}

# Deploy Redis
resource "helm_release" "redis" {
  name      = "redis"
  chart     = "${path.module}/../helm/infra/redis"
  namespace = kubernetes_namespace.stackai_data.metadata[0].name

  values = [
    file("${path.module}/values/redis-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_data]
}

# Deploy PostgreSQL
resource "helm_release" "postgres" {
  name      = "postgres"
  chart     = "${path.module}/../helm/infra/postgres"
  namespace = kubernetes_namespace.stackai_data.metadata[0].name

  values = [
    file("${path.module}/values/postgres-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_data]
}

# Deploy Weaviate
resource "helm_release" "weaviate" {
  name      = "weaviate"
  chart     = "${path.module}/../helm/infra/weaviate"
  namespace = kubernetes_namespace.stackai_data.metadata[0].name

  values = [
    file("${path.module}/values/weaviate-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_data]
}

# Deploy Supabase
resource "helm_release" "supabase" {
  name      = "supabase"
  chart     = "${path.module}/../helm/infra/supabase"
  namespace = kubernetes_namespace.stackai_infra.metadata[0].name

  values = [
    file("${path.module}/values/supabase-dev.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_infra,
    helm_release.nginx_ingress
  ]
}

# Deploy Temporal
resource "helm_release" "temporal" {
  name      = "temporal"
  chart     = "${path.module}/../helm/app/temporal"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/temporal-dev.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    helm_release.nginx_ingress,
    helm_release.postgres
  ]
}

# Deploy Unstructured
resource "helm_release" "unstructured" {
  name      = "unstructured"
  chart     = "${path.module}/../helm/app/unstructured"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/unstructured-dev.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    helm_release.nginx_ingress
  ]
}

# Deploy Stackend - THIRD in the application deployment order
resource "helm_release" "stackend" {
  name      = "stackend"
  chart     = "${path.module}/../helm/app/stackend"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/stakend-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    time_sleep.repl_wait
  ]
}

# Wait for Stackend to be ready
resource "time_sleep" "stackend_wait" {
  depends_on      = [helm_release.stackend]
  create_duration = "30s"
}

# Deploy Stackweb - FOURTH in the application deployment order
resource "helm_release" "stackweb" {
  name      = "stackweb"
  chart     = "${path.module}/../helm/app/stackweb"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/stakweb-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    time_sleep.stackend_wait
  ]
}

# Deploy Celery - FIRST in the application deployment order
resource "helm_release" "celery" {
  name      = "celery"
  chart     = "${path.module}/../helm/app/celery"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/celery-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    time_sleep.infrastructure_ready
  ]
}

# Wait for Celery to be ready
resource "time_sleep" "celery_wait" {
  depends_on      = [helm_release.celery]
  create_duration = "30s"
}

# Deploy Repl - SECOND in the application deployment order
resource "helm_release" "repl" {
  name      = "repl"
  chart     = "${path.module}/../helm/app/repl"
  namespace = kubernetes_namespace.stackai_processing.metadata[0].name

  values = [
    file("${path.module}/values/repl-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.stackai_processing,
    time_sleep.celery_wait
  ]
}

# Wait for Repl to be ready
resource "time_sleep" "repl_wait" {
  depends_on      = [helm_release.repl]
  create_duration = "30s"
}
