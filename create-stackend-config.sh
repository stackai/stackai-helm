#!/bin/bash

# Get service URLs as environment variables
source <(bash get-service-urls.sh)

# Create stackend configuration
cat <<STACKEND_CONFIG > stackend-test-values.yaml
# Stackend Backend - Test Configuration matching Docker Compose
stackend:
  enabled: true
  replicaCount: 1
  image:
    repository: "stackai.azurecr.io/stackai/stackend-backend"
    tag: "latest"
    pullPolicy: Always
  
  service:
    type: ClusterIP
    ports:
      http: 8000
  
  resources:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1000m
  
  env:
    # Basic Configuration
    ENVIRONMENT: "production"
    DEPLOYMENT_ENVIRONMENT: "production_stackend"
    
    # Networking URLs
    STACKEND_API_URL: "${STACKEND_API_URL}"
    INDEXING_API_URL: "${INDEXING_API_URL}"
    STACKWEB_URL: "${STACKWEB_URL}"
    
    # Database Configuration
    POSTGRES_DB_HOST: "${POSTGRES_DB_HOST}"
    POSTGRES_DB_PORT: "${POSTGRES_DB_PORT}"
    POSTGRES_DB_NAME: "${POSTGRES_DB_NAME}"
    POSTGRES_DB_USER: "${POSTGRES_DB_USER}"
    POSTGRES_DB_PASSWORD: "${POSTGRES_DB_PASSWORD}"
    
    # MongoDB Configuration
    MONGODB_URI: "${MONGODB_URI}"
    
    # Redis Configuration
    REDIS_URL: "${REDIS_URL}"
    CELERY_BROKER_URL: "${CELERY_BROKER_URL}"
    CELERY_BACKEND_URL: "${CELERY_BACKEND_URL}"
    
    # Supabase Configuration
    SUPABASE_URL: "${SUPABASE_URL}"
    SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzU3NjA4NjcyLCJleHAiOjE5MTUyODg2NzJ9.MDChWtCkQmjb8NgWqjbP4maPiJpzXVrZfUfkpmdeKl4"
    SUPABASE_SERVICE_ROLE_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NTc2MDg2NzIsImV4cCI6MTkxNTI4ODY3Mn0.qklw1dXhwnBGK-ONTaM3j91l1DLRjt_cE-gLF_gCbGU"
    supabase_encryption_key: "9FJzOjIuJUYY4LBCt1Ucod8Adq+Q+hQIQBS3FdyOYJY="
    
    # Weaviate Configuration
    WEAVIATE_URL: "${WEAVIATE_URL}"
    WEAVIATE_KEY: "q-ozLg7TE2mW"
    SELF_HOSTED_WEAVIATE: "true"
    
    # Unstructured Configuration
    UNSTRUCTURED_URL: "${UNSTRUCTURED_URL}"
    UNSTRUCTURED_API_KEY: "qh6KzV33C1bG"
    
    # Temporal Configuration
    TEMPORAL_HOST: "${TEMPORAL_HOST}"
    TEMPORAL_PORT: "${TEMPORAL_PORT}"
    
    # StackAI License
    STACKAI_LICENCE: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRfbmFtZSI6IkZvbnNpIiwiZXhwaXJ5X2RhdGUiOiIyMDI1LTEyLTMxVDAwOjAwOjAwKzAwOjAwIn0.p8sy6-uG7-8JRU8jvQPWoEfwobFLFL-fD6ireP1pUIs"
    
    # Flow Configuration
    ALLOW_PARALLEL_FLOW_EXECUTION: "true"
    
    # S3/MinIO Configuration (using placeholder values for testing)
    S3_ENDPOINT_URL: "http://localhost:9000"
    S3_USERCONTENT_PUBLIC_BUCKET: "stack-ai-usercontent"
    S3_AWS_ACCESS_KEY: "supa-storage"
    S3_AWS_REGION: "us-east-1"
    S3_AWS_SECRET_ACCESS_KEY: "LjgV1GjKVrNwyoxBGD3wvgcgVejXI2hh"
    
    # OpenAI Configuration (using your keys)
    OPENAI_API_KEY: "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"
    OPENAI_API_KEY_1: "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"
    
    # Disable external secrets for testing
    secrets:
      useExternalSecrets: false

  # Health checks with longer timeouts for testing
  livenessProbe:
    enabled: true
    httpGet:
      path: /health
      port: http
      scheme: HTTP
    initialDelaySeconds: 120
    periodSeconds: 30
    timeoutSeconds: 10
    failureThreshold: 5
    successThreshold: 1

  readinessProbe:
    enabled: true
    httpGet:
      path: /health
      port: http
      scheme: HTTP
    initialDelaySeconds: 60
    periodSeconds: 10
    timeoutSeconds: 10
    failureThreshold: 5
    successThreshold: 1

# Ingress for testing
ingress:
  enabled: true
  className: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS, PATCH"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,apikey,x-client-info"
  hosts:
    - host: localhost
      paths:
        - path: /api
          pathType: Prefix

externalSecrets:
  enabled: false

serviceAccount:
  create: true
  automount: true
STACKEND_CONFIG

echo "✅ Stackend configuration created: stackend-test-values.yaml"

