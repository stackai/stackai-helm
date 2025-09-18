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

# Create PostgreSQL values for development
print_status "Creating PostgreSQL development values..."
cat <<EOF > dev-values/postgres-dev.yaml
postgres:
  enabled: true
  image:
    repository: postgres
    tag: "15.8"
    pullPolicy: IfNotPresent

  database:
    name: temporal
    username: temporal
    password: "temporal-dev-password"
    superuser: postgres
    superuserPassword: "postgres-dev-password"

  service:
    type: ClusterIP
    port: 5432

  persistence:
    enabled: true
    size: 5Gi
    storageClass: ""
    accessModes:
      - ReadWriteOnce

  resources:
    requests:
      memory: 256Mi
      cpu: 100m
    limits:
      memory: 512Mi
      cpu: 500m

  securityContext:
    enabled: true
    runAsUser: 999
    runAsGroup: 999
    runAsNonRoot: true
    fsGroup: 999

  podSecurityContext:
    enabled: true
    runAsUser: 999
    runAsGroup: 999
    runAsNonRoot: true
    fsGroup: 999

  env:
    POSTGRES_DB: temporal
    POSTGRES_USER: temporal
    POSTGRES_PASSWORD: temporal-dev-password
    POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"

  livenessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 3
    successThreshold: 1

  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 3
    successThreshold: 1

serviceAccount:
  create: true
  automount: true
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
    POSTGRES_SEEDS: "postgres.stackai-data.svc.cluster.local"
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
    cors-allow-origin: "*"
    cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    cors-allow-headers: "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,apikey"

defaultBackend:
  enabled: true
  resources:
    requests:
      memory: 32Mi
      cpu: 10m
    limits:
      memory: 64Mi
      cpu: 50m

# Service Routing Configuration
serviceRouting:
  enabled: true
  services:
    argocd:
      enabled: true
      path: /argocd
      service: argocd-server
      port: 80
    supabase:
      enabled: true
      studio:
        path: /supabase/studio
        service: supabase-studio
        port: 3000
      api:
        path: /supabase/rest
        service: supabase-kong
        port: 8000
      auth:
        path: /supabase/auth
        service: supabase-kong
        port: 8000
      realtime:
        path: /supabase/realtime
        service: supabase-kong
        port: 8000
      graphql:
        path: /supabase/graphql
        service: supabase-kong
        port: 8000
      storage:
        path: /supabase/storage
        service: supabase-kong
        port: 8000
      functions:
        path: /supabase/functions
        service: supabase-kong
        port: 8000
    temporal:
      enabled: true
      path: /temporal
      service: temporal-web
      port: 8088
    unstructured:
      enabled: true
      path: /unstructured
      service: unstructured
      port: 8000
    weaviate:
      enabled: true
      path: /weaviate
      service: weaviate
      port: 8080
    mongodb:
      enabled: true
      path: /mongodb
      service: mongodb
      port: 27017
    redis:
      enabled: true
      path: /redis
      service: redis
      port: 6379
    postgres:
      enabled: true
      path: /postgres
      service: postgres
      port: 5432
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

# Deploy PostgreSQL
print_status "Deploying PostgreSQL..."
helm upgrade --install postgres ./helm/infra/postgres \
    --namespace stackai-data \
    --values dev-values/postgres-dev.yaml \
    --wait --timeout=300s

# Deploy NGINX Ingress Controller
print_status "Deploying NGINX Ingress Controller..."
helm upgrade --install nginx ./helm/infra/nginx \
    --namespace nginx-ingress \
    --create-namespace \
    --values dev-values/nginx-dev.yaml \
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
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgres -n stackai-data --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=nginx-ingress-controller -n nginx-ingress --timeout=300s
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

# PostgreSQL ArgoCD Application
cat <<EOF > argocd-apps/postgres-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: postgres
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/postgres
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/postgres-dev.yaml
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

# NGINX ArgoCD Application
cat <<EOF > argocd-apps/nginx-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
  namespace: argocd
spec:
  project: default
  source:
    repoURL: .
    path: helm/infra/nginx
    targetRevision: HEAD
    helm:
      valueFiles:
        - ../../../dev-values/nginx-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: nginx-ingress
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

cat <<EOF > scripts/port-forward-postgres.sh
#!/bin/bash
echo "Port forwarding PostgreSQL to localhost:5432"
echo "Database: temporal"
echo "Username: temporal"
echo "Password: temporal-dev-password"
kubectl port-forward svc/postgres -n stackai-data 5432:5432
EOF

cat <<EOF > scripts/port-forward-nginx.sh
#!/bin/bash
echo "🚀 Port forwarding NGINX to localhost:8080"
echo ""
echo "All services are now accessible through NGINX routing:"
echo "- Services Overview: http://localhost:8080/"
echo "- ArgoCD: http://localhost:8080/argocd"
echo "- Supabase Studio: http://localhost:8080/supabase/studio"
echo "- Supabase API: http://localhost:8080/supabase/rest"
echo "- Temporal Web UI: http://localhost:8080/temporal"
echo "- Unstructured API: http://localhost:8080/unstructured"
echo "- Weaviate: http://localhost:8080/weaviate"
echo ""
echo "Starting port-forward..."
kubectl port-forward svc/nginx-ingress-controller -n nginx-ingress 8080:80
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
- PostgreSQL: stackai-data namespace
- NGINX Ingress: nginx-ingress namespace
- Supabase: stackai-infra namespace
- Temporal: stackai-processing namespace
- Unstructured: stackai-processing namespace
- ArgoCD: argocd namespace

Access Information (via NGINX routing on localhost:8080):
- Services Overview: http://localhost:8080/
- ArgoCD UI: http://localhost:8080/argocd (admin/$(cat ~/.argocd-password 2>/dev/null || echo "check ~/.argocd-password"))
- Supabase Studio: http://localhost:8080/supabase/studio (supabase/stackai-dev-studio-password)
- Supabase API: http://localhost:8080/supabase/rest
- Temporal Web UI: http://localhost:8080/temporal
- Unstructured API: http://localhost:8080/unstructured
- Weaviate: http://localhost:8080/weaviate
- MongoDB: http://localhost:8080/mongodb (admin/stackai-dev-password)
- Redis: http://localhost:8080/redis
- PostgreSQL: http://localhost:8080/postgres (temporal/temporal-dev-password)

Direct Access (individual port-forward):
- MongoDB: localhost:27017 (admin/stackai-dev-password)
- Redis: localhost:6379
- PostgreSQL: localhost:5432 (temporal/temporal-dev-password)
- Weaviate: localhost:8081
- Temporal Frontend: localhost:7233

Port Forward Scripts:
- ./scripts/port-forward-nginx.sh (RECOMMENDED - All services via NGINX)
- ./scripts/port-forward-argocd.sh (individual)
- ./scripts/port-forward-supabase.sh (individual)
- ./scripts/port-forward-weaviate.sh (individual)
- ./scripts/port-forward-temporal.sh (individual)
- ./scripts/port-forward-unstructured.sh (individual)
- ./scripts/port-forward-mongodb.sh (individual)
- ./scripts/port-forward-redis.sh (individual)
- ./scripts/port-forward-postgres.sh (individual)

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
echo "🚀 RECOMMENDED: Single Access Point via NGINX"
echo "- Run './scripts/port-forward-nginx.sh' then visit http://localhost:8080"
echo "- All services accessible through NGINX routing with dedicated paths"
echo ""
echo "📋 Service Access via NGINX (localhost:8080):"
echo "- Services Overview: http://localhost:8080/"
echo "- ArgoCD UI: http://localhost:8080/argocd"
echo "- Supabase Studio: http://localhost:8080/supabase/studio"
echo "- Temporal Web UI: http://localhost:8080/temporal"
echo "- Unstructured API: http://localhost:8080/unstructured"
echo "- Weaviate: http://localhost:8080/weaviate"
echo ""
echo "🔧 Individual Service Access (if needed):"
echo "- ArgoCD: Run './scripts/port-forward-argocd.sh' then visit http://localhost:8080"
echo "- Supabase: Run './scripts/port-forward-supabase.sh' then visit http://localhost:3000"
echo "- Temporal: Run './scripts/port-forward-temporal.sh' then visit http://localhost:8088"
echo "- Unstructured: Run './scripts/port-forward-unstructured.sh' then visit http://localhost:8082"
echo ""
echo "📊 Management:"
echo "- Service Status: Run './scripts/check-services.sh'"
echo "- Interactive Dashboard: Run 'k9s'"
echo "- All services are managed by ArgoCD for GitOps workflow!"
echo ""
