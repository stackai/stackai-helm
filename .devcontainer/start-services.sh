#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🚀 Starting StackAI Infrastructure Services..."

# Check if cluster is running
if ! kubectl cluster-info > /dev/null 2>&1; then
    print_error "Kubernetes cluster is not accessible. Please run setup.sh first."
    exit 1
fi

# Create local values directory for development
mkdir -p dev-values

# Create MongoDB values for development
print_status "Creating MongoDB development values..."
cat <<EOF > dev-values/mongodb-dev.yaml
mongodb:
  enabled: true
  replicaCount: 1
  image:
    tag: "7.0"
  auth:
    enabled: true
    rootUsername: admin
    rootPassword: "stackai-dev-password"
    rootDatabase: admin
  persistence:
    enabled: true
    size: 5Gi
  resources:
    requests:
      memory: 256Mi
      cpu: 100m
    limits:
      memory: 512Mi
      cpu: 500m
EOF

# Create Redis values for development
print_status "Creating Redis development values..."
cat <<EOF > dev-values/redis-dev.yaml
redis:
  enabled: true
  auth:
    enabled: false
  persistence:
    enabled: true
    size: 2Gi
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 256Mi
      cpu: 200m
EOF

# Create Weaviate values for development
print_status "Creating Weaviate development values..."
cat <<EOF > dev-values/weaviate-dev.yaml
weaviate:
  enabled: true
  image:
    tag: "1.25.0"
  persistence:
    enabled: true
    size: 10Gi
  resources:
    requests:
      memory: 512Mi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 500m
  configuration: |
    QUERY_DEFAULTS_LIMIT=25
    AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true
    PERSISTENCE_DATA_PATH=./data
    DEFAULT_VECTORIZER_MODULE=none
    ENABLE_MODULES=text2vec-openai,generative-openai,qna-openai
    CLUSTER_HOSTNAME=node1
    LOG_LEVEL=info
EOF

# Create Temporal values for development
print_status "Creating Temporal development values..."
cat <<EOF > dev-values/temporal-dev.yaml
temporal:
  enabled: true
  image:
    repository: "temporalio/auto-setup"
    tag: "1.24.2"
  replicaCount: 1
  resources:
    requests:
      memory: 512Mi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 500m
  env:
    DB: "postgresql"
    DB_PORT: "5432"
    POSTGRES_USER: "temporal"
    POSTGRES_PWD: "temporal-dev-password"
    POSTGRES_SEEDS: "supabase-db.stackai-infra.svc.cluster.local"
    DYNAMIC_CONFIG_FILE_PATH: "config/dynamicconfig/development-sql.yaml"
    ENABLE_ES: "false"
    secrets:
      useExternalSecrets: false

temporalWeb:
  enabled: true
  image:
    repository: "temporalio/web"
    tag: "2.29.0"
  replicaCount: 1
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 256Mi
      cpu: 200m
  env:
    TEMPORAL_ADDRESS: "temporal-server:7233"
    TEMPORAL_CORS_ORIGINS: "http://localhost:8088"

ingress:
  enabled: false

externalSecrets:
  enabled: false
EOF

# Create Unstructured values for development
print_status "Creating Unstructured development values..."
cat <<EOF > dev-values/unstructured-dev.yaml
unstructured:
  enabled: true
  image:
    repository: downloads.unstructured.io/unstructured-io/unstructured-api
    tag: "0.0.80"
  replicaCount: 1
  resources:
    requests:
      memory: 512Mi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 500m
  env:
    DEBUG: "true"
    ENVIRONMENT: "development"
    LOG_LEVEL: "INFO"
    UNSTRUCTURED_PARALLEL_MODE_ENABLED: "false"
    UNSTRUCTURED_PARALLEL_MODE_THREADS: "3"
    UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE: "1"
    UNSTRUCTURED_PARALLEL_MODE_RETRY_ATTEMPTS: "2"
    UNSTRUCTURED_API_KEY: ""
    DATABASE_URL: ""

ingress:
  enabled: false

externalSecrets:
  enabled: false
EOF

# Create Supabase values for development
print_status "Creating Supabase development values..."
cat <<EOF > dev-values/supabase-dev.yaml
externalURL: "http://localhost:8000"

jwt:
  exp: 3600
  secret: "stackai-dev-jwt-secret-with-at-least-32-characters-long"
  anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
  serviceKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU"

db:
  type: internal
  internal:
    password: "stackai-dev-postgres-password"

studio:
  username: supabase
  password: "stackai-dev-studio-password"

auth:
  enabled: true
  disableSignup: false
  email:
    enabled: false

meta:
  enabled: true

rest:
  enabled: true

realtime:
  enabled: true
  selfHosted: true

functions:
  enabled: true
  verifyJWT: false

storage:
  enabled: false

analytics:
  enabled: false
EOF

# Create NGINX Ingress values for development
print_status "Creating NGINX Ingress development values..."
cat <<EOF > dev-values/nginx-dev.yaml
controller:
  enabled: true
  replicaCount: 1
  service:
    type: NodePort
    ports:
      http: 80
      https: 443
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 256Mi
      cpu: 200m
  config:
    enable-access-log-for-default-backend: "true"
    proxy-connect-timeout: "60"
    proxy-send-timeout: "60"
    proxy-read-timeout: "60"

defaultBackend:
  enabled: true
  resources:
    requests:
      memory: 32Mi
      cpu: 10m
    limits:
      memory: 64Mi
      cpu: 50m
EOF

# Deploy MongoDB
print_status "Deploying MongoDB..."
helm upgrade --install mongodb ./helm/infra/mongo \
    --namespace stackai-data \
    --values dev-values/mongodb-dev.yaml \
    --wait --timeout=300s

# Deploy Redis
print_status "Deploying Redis..."
helm upgrade --install redis ./helm/infra/redis \
    --namespace stackai-data \
    --values dev-values/redis-dev.yaml \
    --wait --timeout=300s

# Deploy Weaviate
print_status "Deploying Weaviate..."
helm upgrade --install weaviate ./helm/infra/weviate \
    --namespace stackai-data \
    --values dev-values/weaviate-dev.yaml \
    --wait --timeout=300s

# Deploy Supabase
print_status "Deploying Supabase..."
helm upgrade --install supabase ./helm/infra/supabase \
    --namespace stackai-infra \
    --values dev-values/supabase-dev.yaml \
    --wait --timeout=600s

# Deploy Temporal
print_status "Deploying Temporal..."
helm upgrade --install temporal ./helm/app/temporal \
    --namespace stackai-processing \
    --values dev-values/temporal-dev.yaml \
    --wait --timeout=600s

# Deploy Unstructured
print_status "Deploying Unstructured..."
helm upgrade --install unstructured ./helm/app/unstructured \
    --namespace stackai-processing \
    --values dev-values/unstructured-dev.yaml \
    --wait --timeout=300s

# Wait for services to be ready
print_status "Waiting for services to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-mongodb -n stackai-data --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-redis -n stackai-data --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-weaviate -n stackai-data --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-supabase -n stackai-infra --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-temporal -n stackai-processing --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=stackai-unstructured -n stackai-processing --timeout=300s

# Create ArgoCD applications for GitOps management
print_status "Creating ArgoCD applications..."
mkdir -p argocd-apps

# MongoDB ArgoCD Application
cat <<EOF > argocd-apps/mongodb-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mongodb
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/mongo
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/mongodb-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-data
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Redis ArgoCD Application
cat <<EOF > argocd-apps/redis-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: redis
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/redis
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/redis-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-data
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Weaviate ArgoCD Application
cat <<EOF > argocd-apps/weaviate-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: weaviate
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/weviate
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/weaviate-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-data
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Supabase ArgoCD Application
cat <<EOF > argocd-apps/supabase-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: supabase
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/supabase
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/supabase-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-infra
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Temporal ArgoCD Application
cat <<EOF > argocd-apps/temporal-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: temporal
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/app/temporal
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/temporal-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-processing
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Unstructured ArgoCD Application
cat <<EOF > argocd-apps/unstructured-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: unstructured
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/app/unstructured
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/unstructured-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: stackai-processing
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

# Apply ArgoCD applications
print_status "Applying ArgoCD applications..."
kubectl apply -f argocd-apps/

print_success "ArgoCD applications created!"

# Create port-forward scripts
print_status "Creating port-forward scripts..."
mkdir -p scripts

cat <<EOF > scripts/port-forward-argocd.sh
#!/bin/bash
echo "Port forwarding ArgoCD UI to http://localhost:8080"
kubectl port-forward svc/argocd-server -n argocd 8080:443
EOF

cat <<EOF > scripts/port-forward-supabase.sh
#!/bin/bash
echo "Port forwarding Supabase Studio to http://localhost:3000"
kubectl port-forward svc/supabase-kong -n stackai-infra 8000:8000 &
kubectl port-forward svc/supabase-studio -n stackai-infra 3000:3000 &
wait
EOF

cat <<EOF > scripts/port-forward-weaviate.sh
#!/bin/bash
echo "Port forwarding Weaviate to http://localhost:8081"
kubectl port-forward svc/weaviate -n stackai-data 8081:8080
EOF

cat <<EOF > scripts/port-forward-mongodb.sh
#!/bin/bash
echo "Port forwarding MongoDB to localhost:27017"
kubectl port-forward svc/mongodb -n stackai-data 27017:27017
EOF

cat <<EOF > scripts/port-forward-redis.sh
#!/bin/bash
echo "Port forwarding Redis to localhost:6379"
kubectl port-forward svc/redis -n stackai-data 6379:6379
EOF

cat <<EOF > scripts/port-forward-temporal.sh
#!/bin/bash
echo "Port forwarding Temporal Web UI to http://localhost:8088"
echo "Port forwarding Temporal Frontend to localhost:7233"
kubectl port-forward svc/temporal-web -n stackai-processing 8088:8088 &
kubectl port-forward svc/temporal-server -n stackai-processing 7233:7233 &
wait
EOF

cat <<EOF > scripts/port-forward-unstructured.sh
#!/bin/bash
echo "Port forwarding Unstructured API to http://localhost:8082"
kubectl port-forward svc/unstructured -n stackai-processing 8082:8000
EOF

chmod +x scripts/*.sh

# Create service status script
cat <<EOF > scripts/check-services.sh
#!/bin/bash
echo "StackAI Development Environment Status"
echo "======================================"
echo ""
echo "Namespaces:"
kubectl get namespaces | grep -E "(stackai|argocd)"
echo ""
echo "Pods Status:"
kubectl get pods -n stackai-data
kubectl get pods -n stackai-infra
kubectl get pods -n stackai-processing
kubectl get pods -n argocd
echo ""
echo "Services:"
kubectl get svc -n stackai-data
kubectl get svc -n stackai-infra
kubectl get svc -n stackai-processing
echo ""
echo "ArgoCD Applications:"
kubectl get applications -n argocd
EOF

chmod +x scripts/check-services.sh

# Save service information
cat <<EOF > ~/.stackai-dev/services-info.txt
StackAI Development Services
============================

Services Deployed:
- MongoDB: stackai-data namespace
- Redis: stackai-data namespace  
- Weaviate: stackai-data namespace
- Supabase: stackai-infra namespace
- Temporal: stackai-processing namespace
- Unstructured: stackai-processing namespace
- ArgoCD: argocd namespace

Access Information:
- ArgoCD UI: http://localhost:8080 (admin/$(cat ~/.argocd-password 2>/dev/null || echo "check ~/.argocd-password"))
- Supabase Studio: http://localhost:3000 (supabase/stackai-dev-studio-password)
- Supabase API: http://localhost:8000
- Weaviate: http://localhost:8081
- Temporal Web UI: http://localhost:8088
- Temporal Frontend: localhost:7233
- Unstructured API: http://localhost:8082
- MongoDB: localhost:27017 (admin/stackai-dev-password)
- Redis: localhost:6379

Port Forward Scripts:
- ./scripts/port-forward-argocd.sh
- ./scripts/port-forward-supabase.sh
- ./scripts/port-forward-weaviate.sh
- ./scripts/port-forward-temporal.sh
- ./scripts/port-forward-unstructured.sh
- ./scripts/port-forward-mongodb.sh
- ./scripts/port-forward-redis.sh

Status Check:
- ./scripts/check-services.sh

Useful Commands:
- k9s: Interactive Kubernetes dashboard
- kubectl logs -f <pod-name> -n <namespace>: Follow logs
- stern <service-name> -n <namespace>: Stream logs from all pods
EOF

print_success "All infrastructure services deployed successfully!"
print_success "Service information saved to ~/.stackai-dev/services-info.txt"

echo ""
echo "🎉 StackAI Infrastructure Services are ready!"
echo ""
echo "Quick Access:"
echo "- ArgoCD UI: Run './scripts/port-forward-argocd.sh' then visit http://localhost:8080"
echo "- Supabase: Run './scripts/port-forward-supabase.sh' then visit http://localhost:3000"
echo "- Temporal: Run './scripts/port-forward-temporal.sh' then visit http://localhost:8088"
echo "- Unstructured: Run './scripts/port-forward-unstructured.sh' then visit http://localhost:8082"
echo "- Service Status: Run './scripts/check-services.sh'"
echo "- Interactive Dashboard: Run 'k9s'"
echo ""
echo "All services are managed by ArgoCD for GitOps workflow!"
echo ""
