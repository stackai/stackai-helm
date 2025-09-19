# Deploy Custom Nginx Ingress Controller
resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  chart     = "${path.module}/../helm/infra/nginx"
  namespace = kubernetes_namespace.stackai_infra.metadata[0].name

  values = [
    file("${path.module}/values/nginx-dev.yaml")
  ]

  depends_on = [kubernetes_namespace.stackai_infra]
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
  chart     = "${path.module}/../helm/infra/weviate"
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
