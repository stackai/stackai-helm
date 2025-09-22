output "argocd_url" {
  description = "ArgoCD URL"
  value       = "http://argocd.localhost"
}

output "argocd_admin_password" {
  description = "ArgoCD admin password"
  value       = "Use: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  sensitive   = true
}

output "supabase_url" {
  description = "Supabase URL"
  value       = "http://supabase.localhost"
}

output "temporal_web_url" {
  description = "Temporal Web UI URL"
  value       = "http://temporal.localhost"
}

output "weaviate_web_url" {
  description = "Weaviate Web UI URL"
  value       = "http://weaviate.localhost"
}

output "mongodb_connection_string" {
  description = "MongoDB connection string"
  value       = "mongodb://admin:stackai-dev-password@mongodb.stackai-data.svc.cluster.local:27017/admin"
}

output "redis_connection_string" {
  description = "Redis connection string"
  value       = "redis://redis.stackai-data.svc.cluster.local:6379"
}

output "postgres_connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://temporal:temporal-dev-password@postgres.stackai-data.svc.cluster.local:5432/temporal"
}

output "weaviate_url" {
  description = "Weaviate API URL"
  value       = "http://weaviate.stackai-data.svc.cluster.local:8080"
}

output "supabase_api_url" {
  description = "Supabase API URL"
  value       = "http://supabase.localhost"
}

output "namespaces" {
  description = "Created namespaces"
  value = {
    argocd         = kubernetes_namespace.argocd.metadata[0].name
    stackai_infra  = kubernetes_namespace.stackai_infra.metadata[0].name
    stackai_data   = kubernetes_namespace.stackai_data.metadata[0].name
    stackai_processing = kubernetes_namespace.stackai_processing.metadata[0].name
  }
}

output "helm_releases" {
  description = "Deployed Helm releases"
  value = {
    argocd         = helm_release.argocd.name
    nginx_ingress  = helm_release.nginx_ingress.name
    mongodb        = helm_release.mongodb.name
    redis          = helm_release.redis.name
    postgres       = helm_release.postgres.name
    weaviate       = helm_release.weaviate.name
    supabase       = helm_release.supabase.name
    temporal       = helm_release.temporal.name
  }
}

output "stackend_url" {
  description = "Stackend URL"
  value       = "http://stackend.localhost"
}

output "stackweb_url" {
  description = "Stackweb URL"
  value       = "http://stackweb.localhost"
}

output "celery_url" {
  description = "Celery URL"
  value       = "http://celery.localhost"
}

output "repl_url" {
  description = "Repl URL"
  value       = "http://repl-api.localhost"
}

output "unstructured_url" {
  description = "Unstructured URL"
  value       = "http://unstructured.localhost"
}
