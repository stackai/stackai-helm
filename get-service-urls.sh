#!/bin/bash

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}🔍 Getting Service URLs and Ports...${NC}"

# Get service URLs for environment variables
echo "# ========================================="
echo "# SERVICE URLS FOR ENVIRONMENT VARIABLES"
echo "# ========================================="

# MongoDB URL
MONGODB_HOST=$(kubectl get svc mongodb -n stackai-data -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "mongodb.stackai-data.svc.cluster.local")
MONGODB_PORT="27017"
MONGODB_URL="mongodb://admin:stackai-dev-password@${MONGODB_HOST}:${MONGODB_PORT}/stackend"
echo "export MONGODB_URI=\"${MONGODB_URL}\""

# Redis URL
REDIS_HOST=$(kubectl get svc redis -n stackai-data -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "redis.stackai-data.svc.cluster.local")
REDIS_PORT="6379"
REDIS_URL="redis://${REDIS_HOST}:${REDIS_PORT}"
echo "export REDIS_URL=\"${REDIS_URL}\""
echo "export CELERY_BROKER_URL=\"${REDIS_URL}\""
echo "export CELERY_BACKEND_URL=\"${REDIS_URL}\""

# PostgreSQL URL
POSTGRES_HOST=$(kubectl get svc postgres -n stackai-data -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "postgres.stackai-data.svc.cluster.local")
POSTGRES_PORT="5432"
POSTGRES_URL="postgresql://temporal:temporal-dev-password@${POSTGRES_HOST}:${POSTGRES_PORT}/stackend"
echo "export POSTGRES_DB_HOST=\"${POSTGRES_HOST}\""
echo "export POSTGRES_DB_PORT=\"${POSTGRES_PORT}\""
echo "export POSTGRES_DB_USER=\"temporal\""
echo "export POSTGRES_DB_PASSWORD=\"temporal-dev-password\""
echo "export POSTGRES_DB_NAME=\"stackend\""

# Supabase URL
SUPABASE_HOST=$(kubectl get svc supabase-kong -n stackai-infra -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "supabase-kong.stackai-infra.svc.cluster.local")
SUPABASE_PORT="8000"
SUPABASE_URL="http://${SUPABASE_HOST}:${SUPABASE_PORT}"
echo "export SUPABASE_URL=\"${SUPABASE_URL}\""

# Weaviate URL
WEAVIATE_HOST=$(kubectl get svc weaviate -n stackai-data -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "weaviate.stackai-data.svc.cluster.local")
WEAVIATE_PORT="8080"
echo "export WEAVIATE_URL=\"${WEAVIATE_HOST}\""

# Unstructured URL
UNSTRUCTURED_HOST=$(kubectl get svc unstructured -n stackai-processing -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "unstructured.stackai-processing.svc.cluster.local")
UNSTRUCTURED_PORT="8000"
UNSTRUCTURED_URL="http://${UNSTRUCTURED_HOST}:${UNSTRUCTURED_PORT}/general/v0/general"
echo "export UNSTRUCTURED_URL=\"${UNSTRUCTURED_URL}\""

# Temporal URL
TEMPORAL_HOST=$(kubectl get svc temporal-server -n stackai-processing -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "temporal-server.stackai-processing.svc.cluster.local")
TEMPORAL_PORT="7233"
echo "export TEMPORAL_HOST=\"${TEMPORAL_HOST}\""
echo "export TEMPORAL_PORT=\"${TEMPORAL_PORT}\""

# External URLs (for stackend to advertise itself)
echo "export STACKEND_API_URL=\"http://localhost:9000\""
echo "export INDEXING_API_URL=\"http://localhost:9000\""
echo "export STACKWEB_URL=\"http://localhost:3001\""

echo ""
echo -e "${GREEN}✅ Copy the export commands above to set your environment variables${NC}"

