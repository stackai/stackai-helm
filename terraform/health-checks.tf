# Health check resources to ensure services are ready before dependent services start

# Wait for Nginx Ingress to be ready
resource "time_sleep" "nginx_ingress_wait" {
  depends_on = [helm_release.nginx_ingress]
  create_duration = "30s"
}

# Wait for Supabase to be ready
resource "time_sleep" "supabase_wait" {
  depends_on = [helm_release.supabase]
  create_duration = "60s"
}

# Wait for MongoDB to be ready
resource "time_sleep" "mongodb_wait" {
  depends_on = [helm_release.mongodb]
  create_duration = "30s"
}

# Wait for Redis to be ready
resource "time_sleep" "redis_wait" {
  depends_on = [helm_release.redis]
  create_duration = "30s"
}

# Wait for PostgreSQL to be ready
resource "time_sleep" "postgres_wait" {
  depends_on = [helm_release.postgres]
  create_duration = "30s"
}

# Wait for Weaviate to be ready
resource "time_sleep" "weaviate_wait" {
  depends_on = [helm_release.weaviate]
  create_duration = "30s"
}

# Wait for Temporal to be ready
resource "time_sleep" "temporal_wait" {
  depends_on = [helm_release.temporal]
  create_duration = "60s"
}

# Wait for Unstructured to be ready
resource "time_sleep" "unstructured_wait" {
  depends_on = [helm_release.unstructured]
  create_duration = "30s"
}

# Combined wait for all infrastructure services
resource "time_sleep" "infrastructure_ready" {
  depends_on = [
    time_sleep.nginx_ingress_wait,
    time_sleep.supabase_wait,
    time_sleep.mongodb_wait,
    time_sleep.redis_wait,
    time_sleep.postgres_wait,
    time_sleep.weaviate_wait,
    time_sleep.temporal_wait,
    time_sleep.unstructured_wait
  ]
  create_duration = "10s"
}
