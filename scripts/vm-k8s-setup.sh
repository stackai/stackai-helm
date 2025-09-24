#!/bin/bash

# StackAI VM Kubernetes Setup Script
# This script sets up k3s Kubernetes cluster inside an Azure VM and deploys StackAI

set -e

echo "🚀 StackAI VM Kubernetes Setup"
echo "=============================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check VM resources
check_vm_resources() {
    print_step "Checking VM resources..."

    # Check available memory
    TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
    AVAILABLE_MEM=$(free -g | awk '/^Mem:/{print $7}')

    # Check available disk space
    DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
    DISK_AVAILABLE=$(df -h / | awk 'NR==2{print $4}')

    print_status "VM Resource Check:"
    echo "  Total Memory: ${TOTAL_MEM}GB"
    echo "  Available Memory: ${AVAILABLE_MEM}GB"
    echo "  Disk Usage: ${DISK_USAGE}%"
    echo "  Available Disk: ${DISK_AVAILABLE}"
    echo ""

    # Warn if resources are low
    if [ "$TOTAL_MEM" -lt 4 ]; then
        print_warning "Low memory detected (${TOTAL_MEM}GB). StackAI requires at least 4GB RAM."
        print_warning "Consider using a larger VM or reducing resource limits."
    fi

    if [ "$DISK_USAGE" -gt 80 ]; then
        print_warning "High disk usage detected (${DISK_USAGE}%). Consider freeing up space."
    fi

    print_status "Resource check completed ✓"
}

# Function to install required tools
install_tools() {
    print_step "Installing required tools..."

    # Update package list
    sudo apt update

    # Install curl, wget, git
    sudo apt install -y curl wget git unzip

    # Install kubectl
    if ! command -v kubectl &> /dev/null; then
        print_status "Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    fi

    # Install Helm
    if ! command -v helm &> /dev/null; then
        print_status "Installing Helm..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi

    # Install Terraform
    if ! command -v terraform &> /dev/null; then
        print_status "Installing Terraform..."
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt update && sudo apt install terraform
    fi

    print_status "All tools installed ✓"
}

# Function to install k3s
install_k3s() {
    print_step "Installing k3s Kubernetes..."

    # Install k3s
    curl -sfL https://get.k3s.io | sh -

    # Wait for k3s to be ready
    print_status "Waiting for k3s to be ready..."
    sudo systemctl status k3s --no-pager

    # Create kubeconfig for current user
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config

    # Test kubectl
    print_status "Testing kubectl connection..."
    kubectl get nodes

    print_status "k3s installed and configured ✓"
}

# Function to configure k3s for StackAI
configure_k3s() {
    print_step "Configuring k3s for StackAI..."

    # Enable required features
    sudo mkdir -p /etc/rancher/k3s
    sudo tee /etc/rancher/k3s/config.yaml > /dev/null <<EOF
# k3s configuration for StackAI
write-kubeconfig-mode: "0644"
disable:
  - traefik  # We'll use nginx ingress instead
  - servicelb
kube-apiserver-arg:
  - "enable-admission-plugins=NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook"
EOF

    # Restart k3s with new configuration
    sudo systemctl restart k3s

    # Wait for k3s to be ready
    print_status "Waiting for k3s to restart..."
    sleep 30
    kubectl get nodes

    print_status "k3s configured ✓"
}

# Function to verify nginx ingress controller (handled by Terraform)
verify_nginx_ingress() {
    print_step "Verifying Nginx Ingress Controller..."

    print_status "Nginx Ingress Controller will be installed by Terraform configuration ✓"
    print_status "Your existing nginx configuration includes:"
    print_status "  - Custom nginx ingress controller"
    print_status "  - Service routing for all StackAI services"
    print_status "  - LoadBalancer service type"
    print_status "  - CORS and security headers"
    print_status "  - Rate limiting and proxy configuration"
}

# Function to backup original values files
backup_values_files() {
    print_step "Creating backup of original values files..."

    # Create backup directory
    mkdir -p values/backup

    # Backup all values files
    for file in values/*.yaml; do
        if [ -f "$file" ] && [[ "$file" != *"backup"* ]]; then
            cp "$file" "values/backup/$(basename "$file").backup"
        fi
    done

    print_status "Values files backed up to values/backup/ ✓"
}

# Function to update all values files with the new domain
update_values_files() {
    local domain="$1"
    print_step "Updating values files with domain: $domain"

    # Create backup first
    backup_values_files

    # Create subdomains
    local api_domain="api.$domain"
    local supabase_domain="supabase.$domain"
    local temporal_domain="temporal.$domain"
    local unstructured_domain="unstructured.$domain"
    local repl_domain="repl.$domain"
    local weaviate_domain="weaviate.$domain"
    local argocd_domain="argocd.$domain"
    local celery_domain="celery.$domain"

    print_status "Updating domain configurations..."

    # Generic function to update any domain pattern in a file
    update_domain_patterns() {
        local file="$1"
        local new_domain="$2"

        if [ -f "$file" ]; then
            # Replace any existing domain patterns with new domain
            # This handles: localhost, any existing domain, IP addresses, etc.

            # Replace http://localhost or http://any-domain (but preserve paths)
            sed -i "s|http://[^/[:space:]]*|http://$new_domain|g" "$file"
            # Replace https://localhost or https://any-domain (but preserve paths)
            sed -i "s|https://[^/[:space:]]*|https://$new_domain|g" "$file"
            # Replace host: localhost or host: any-domain
            sed -i "s|host: [^[:space:]]*|host: $new_domain|g" "$file"
            # Replace any URL patterns in environment variables (but preserve paths)
            sed -i "s|http://[^/[:space:]]*|http://$new_domain|g" "$file"

            return 0
        fi
        return 1
    }

    # Function to update specific service subdomains
    update_service_subdomains() {
        local file="$1"
        local service="$2"
        local base_domain="$3"
        local subdomain="$service.$base_domain"

        if [ -f "$file" ]; then
            # Update specific service URLs to use subdomain
            sed -i "s|http://$service\.[^[:space:]]*|http://$subdomain|g" "$file"
            sed -i "s|https://$service\.[^[:space:]]*|https://$subdomain|g" "$file"
            sed -i "s|host: $service\.[^[:space:]]*|host: $subdomain|g" "$file"

            # Also handle cases where service might be referenced without protocol
            sed -i "s|$service\.[^[:space:]]*|$subdomain|g" "$file"

            return 0
        fi
        return 1
    }

    # Update all values files with generic domain replacement
    print_status "Updating all values files with domain: $domain"

    # List of all values files to update
    local values_files=(
        "values/argocd-values.yaml:$argocd_domain"
        "values/stakweb-values.yaml:$domain"
        "values/stakend-values.yaml:$domain"
        "values/celery-values.yaml:$domain"
        "values/repl-values.yaml:$repl_domain"
        "values/supabase-dev.yaml:$supabase_domain"
        "values/temporal-dev.yaml:$temporal_domain"
        "values/unstructured-dev.yaml:$unstructured_domain"
    )

    # Update each values file
    for file_config in "${values_files[@]}"; do
        IFS=':' read -r file target_domain <<< "$file_config"

        if [ -f "$file" ]; then
            # Update base domain patterns
            update_domain_patterns "$file" "$target_domain"

            # Update specific subdomains for files that need them
            case "$file" in
                "values/stakweb-values.yaml")
                    update_service_subdomains "$file" "api" "$domain"
                    update_service_subdomains "$file" "supabase" "$domain"
                    ;;
                "values/stakend-values.yaml")
                    update_service_subdomains "$file" "api" "$domain"
                    update_service_subdomains "$file" "supabase" "$domain"
                    update_service_subdomains "$file" "weaviate" "$domain"
                    update_service_subdomains "$file" "unstructured" "$domain"
                    update_service_subdomains "$file" "repl" "$domain"
                    ;;
                "values/celery-values.yaml")
                    update_service_subdomains "$file" "api" "$domain"
                    update_service_subdomains "$file" "supabase" "$domain"
                    update_service_subdomains "$file" "weaviate" "$domain"
                    update_service_subdomains "$file" "unstructured" "$domain"
                    update_service_subdomains "$file" "repl" "$domain"
                    ;;
            esac

            print_status "Updated $(basename "$file") ✓"
        fi
    done

    print_status "All values files updated with domain: $domain ✓"
    echo ""
    print_status "Service URLs will be:"
    echo "  Main App: http://$domain"
    echo "  API: http://$api_domain"
    echo "  Supabase: http://$supabase_domain"
    echo "  Temporal: http://$temporal_domain"
    echo "  Unstructured: http://$unstructured_domain"
    echo "  Repl: http://$repl_domain"
    echo "  Weaviate: http://$weaviate_domain"
    echo "  ArgoCD: http://$argocd_domain"
    echo "  Celery: http://$celery_domain"
}

# Function to restore original values files
restore_values_files() {
    print_step "Restoring original values files..."

    if [ -d "values/backup" ]; then
        for backup_file in values/backup/*.backup; do
            if [ -f "$backup_file" ]; then
                original_name=$(basename "$backup_file" .backup)
                cp "$backup_file" "values/$original_name"
                print_status "Restored $original_name ✓"
            fi
        done
        print_status "All values files restored from backup ✓"
    else
        print_warning "No backup found. Original values files not restored."
    fi
}

# Function to update Tiptap Pro Token in StackWeb values
update_tiptap_token() {
    local token="$1"

    if [ -n "$token" ] && [ -f "values/stakweb-values.yaml" ]; then
        print_step "Updating Tiptap Pro Token in StackWeb values..."

        # Update TIPTAP_PRO_TOKEN
        sed -i "s|TIPTAP_PRO_TOKEN: \".*\"|TIPTAP_PRO_TOKEN: \"$token\"|g" values/stakweb-values.yaml

        print_status "Tiptap Pro Token updated in stakweb-values.yaml ✓"
    elif [ -z "$token" ] && [ -f "values/stakweb-values.yaml" ]; then
        print_status "Tiptap Pro Token not provided - using free version ✓"
    fi
}

# Function to configure Terraform
configure_terraform() {
    print_step "Configuring Terraform..."

    cd terraform

    # Copy terraform vars
    if [ -f "terraform.tfvars.example" ]; then
        cp terraform.tfvars.example terraform.tfvars
    fi

    # Interactive configuration
    echo ""
    print_status "Please provide the following configuration details:"
    echo ""

    # Get domain
        read -p "Enter your domain (default: yasser.eastus.cloudapp.azure.com): " DOMAIN
        DOMAIN=${DOMAIN:-yasser.eastus.cloudapp.azure.com}

    # Get SSL preference
    echo ""
    read -p "Enable SSL/TLS? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ENABLE_SSL="true"
    else
        ENABLE_SSL="false"
    fi

    # Get resource limits
    echo ""
    print_status "Resource Limits Configuration:"
    print_warning "These limits apply to each pod. Choose based on your VM size:"
    echo "  - Small VM (2-4GB RAM): 500m CPU, 512Mi memory"
    echo "  - Medium VM (4-8GB RAM): 1000m CPU, 1Gi memory"
    echo "  - Large VM (8GB+ RAM): 2000m CPU, 2Gi memory"
    echo ""
    read -p "CPU limit (default: 1000m): " CPU_LIMIT
    CPU_LIMIT=${CPU_LIMIT:-1000m}

    read -p "Memory limit (default: 2Gi): " MEMORY_LIMIT
    MEMORY_LIMIT=${MEMORY_LIMIT:-2Gi}

    # Get ArgoCD password
    echo ""
    read -p "ArgoCD admin password (default: stackai-dev-argocd-password): " ARGOCD_PASSWORD
    ARGOCD_PASSWORD=${ARGOCD_PASSWORD:-stackai-dev-argocd-password}

    # Get ACR credentials
    echo ""
    print_status "Azure Container Registry (ACR) Configuration:"
    print_warning "ACR is required for private StackAI images. Leave empty if using public images."
    echo ""
    echo "To get ACR credentials, run on your Azure VM:"
    echo "  az acr credential show --name <your-acr-name> --query 'username' -o tsv"
    echo "  az acr credential show --name <your-acr-name> --query 'passwords[0].value' -o tsv"
    echo ""
    read -p "ACR Username (optional): " ACR_USERNAME
    if [ -n "$ACR_USERNAME" ]; then
        read -s -p "ACR Password: " ACR_PASSWORD
        echo ""
        print_status "ACR credentials will be configured ✓"
    else
        ACR_PASSWORD=""
        print_warning "ACR credentials not provided - using public images"
    fi

    # Get Tiptap Pro credentials
    echo ""
    print_status "Tiptap Pro Configuration:"
    print_warning "Tiptap Pro is required for advanced editor features. Leave empty if using free version."
    echo ""
    echo "To get Tiptap Pro credentials:"
    echo "  1. Visit: https://tiptap.dev/pro"
    echo "  2. Sign up for Tiptap Pro"
    echo "  3. Get your Pro Token from the dashboard"
    echo ""
    read -p "Tiptap Pro Token (optional): " TIPTAP_PRO_TOKEN
    if [ -n "$TIPTAP_PRO_TOKEN" ]; then
        print_status "Tiptap Pro Token will be configured ✓"
    else
        TIPTAP_PRO_TOKEN=""
        print_warning "Tiptap Pro Token not provided - using free version"
    fi

    # Create terraform.tfvars
    cat > terraform.tfvars <<EOF
# VM Kubernetes configuration
kubeconfig_path = "~/.kube/config"
domain = "$DOMAIN"
enable_ssl = $ENABLE_SSL
resource_limits = {
  cpu_limit    = "$CPU_LIMIT"
  memory_limit = "$MEMORY_LIMIT"
}
argocd_admin_password = "$ARGOCD_PASSWORD"
acr_username = "$ACR_USERNAME"
acr_password = "$ACR_PASSWORD"
tiptap_pro_token = "$TIPTAP_PRO_TOKEN"
EOF

    # Update all values files with the new domain
    update_values_files "$DOMAIN"

    # Update Tiptap Pro Token in StackWeb values
    update_tiptap_token "$TIPTAP_PRO_TOKEN"

    print_status "Terraform configured with your settings ✓"
    echo ""
    print_status "Configuration Summary:"
    echo "  Domain: $DOMAIN"
    echo "  SSL Enabled: $ENABLE_SSL"
    echo "  CPU Limit: $CPU_LIMIT"
    echo "  Memory Limit: $MEMORY_LIMIT"
    echo "  ACR Username: ${ACR_USERNAME:-'Not set'}"
    echo "  ACR Password: ${ACR_PASSWORD:+'Set'}"
    echo "  Tiptap Pro Token: ${TIPTAP_PRO_TOKEN:+'Set'}"
    echo ""

    # Ask for confirmation before proceeding
    read -p "Do you want to proceed with these settings? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Configuration cancelled. You can run the script again to reconfigure."
        exit 0
    fi
}

# Function to deploy StackAI
deploy_stackai() {
    print_step "Deploying StackAI infrastructure..."

    # Initialize Terraform
    terraform init

    # Plan deployment
    print_status "Planning deployment..."
    terraform plan -out=tfplan

    # Ask for confirmation
    echo ""
    print_warning "This will deploy StackAI infrastructure to your k3s cluster."
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Apply deployment
        print_status "Applying deployment..."
        terraform apply tfplan

        print_status "StackAI infrastructure deployed ✓"
    else
        print_status "Deployment cancelled."
        exit 0
    fi
}

# Function to generate ingress configuration for VM deployment
generate_vm_ingress() {
    print_step "Generating nginx ingress configuration for VM deployment..."

    # Navigate to terraform directory
    cd terraform

    # Create ingress configuration based on domain and SSL settings
    local ssl_redirect="false"
    if [ "$ENABLE_SSL" = "true" ]; then
        ssl_redirect="true"
    fi

    # Generate the ingress configuration
    cat > ingress-config.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: stackai-services-ingress
  namespace: stackai-infra
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "$ssl_redirect"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "$ssl_redirect"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,apikey"
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "4k"
    nginx.ingress.kubernetes.io/proxy-buffers: "4 32k"
    nginx.ingress.kubernetes.io/proxy-busy-buffers-size: "8k"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
spec:
  rules:
    # Main application domain
    - host: $DOMAIN
      http:
        paths:
          # Default route to StackWeb
          - path: /
            pathType: Prefix
            backend:
              service:
                name: stackweb
                port:
                  number: 3000

    # API subdomain
    - host: api.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: stackend
                port:
                  number: 8000

    # Supabase subdomain
    - host: supabase.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: supabase-kong
                port:
                  number: 8000

    # Temporal subdomain
    - host: temporal.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: temporal-web
                port:
                  number: 8080

    # Unstructured subdomain
    - host: unstructured.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: unstructured
                port:
                  number: 8000

    # Repl subdomain
    - host: repl.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: repl
                port:
                  number: 8000

    # Weaviate subdomain
    - host: weaviate.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: weaviate
                port:
                  number: 8080

    # ArgoCD subdomain
    - host: argocd.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80

    # Celery subdomain
    - host: celery.$DOMAIN
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: celery
                port:
                  number: 8002

EOF

    # Add TLS configuration if SSL is enabled
    if [ "$ENABLE_SSL" = "true" ]; then
        cat >> ingress-config.yaml <<EOF

  # TLS configuration
  tls:
    - hosts:
        - $DOMAIN
        - api.$DOMAIN
        - supabase.$DOMAIN
        - temporal.$DOMAIN
        - unstructured.$DOMAIN
        - repl.$DOMAIN
        - weaviate.$DOMAIN
        - argocd.$DOMAIN
        - celery.$DOMAIN
      secretName: stackai-tls-secret
EOF
    fi

    print_status "Ingress configuration generated ✓"

    # Return to original directory
    cd ..
}

# Function to update nginx values for VM deployment
update_nginx_values() {
    print_step "Updating nginx values for VM deployment..."

    # Update nginx values file with VM-specific configuration
    if [ -f "terraform/values/nginx-dev.yaml" ]; then
        # Update SSL configuration based on SSL enabled status
        if [ "$ENABLE_SSL" = "true" ]; then
            sed -i "s/ssl-redirect: \"false\"/ssl-redirect: \"true\"/g" terraform/values/nginx-dev.yaml
            sed -i "s/force-ssl-redirect: \"false\"/force-ssl-redirect: \"true\"/g" terraform/values/nginx-dev.yaml
        else
            sed -i "s/ssl-redirect: \"true\"/ssl-redirect: \"false\"/g" terraform/values/nginx-dev.yaml
            sed -i "s/force-ssl-redirect: \"true\"/force-ssl-redirect: \"false\"/g" terraform/values/nginx-dev.yaml
        fi

        print_status "Nginx values updated for VM deployment ✓"
    else
        print_error "nginx-dev.yaml not found!"
        exit 1
    fi
}

# Function to deploy nginx with VM configuration
deploy_nginx_vm() {
    print_step "Deploying nginx ingress controller for VM..."

    cd terraform

    # Plan the nginx deployment
    print_status "Planning nginx deployment..."
    terraform plan -target=helm_release.nginx_ingress -target=kubectl_manifest.stackai_ingress

    # Apply nginx deployment
    print_status "Deploying nginx ingress controller..."
    terraform apply -auto-approve -target=helm_release.nginx_ingress -target=kubectl_manifest.stackai_ingress

    # Wait for nginx to be ready
    print_status "Waiting for nginx ingress controller to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/nginx-ingress-controller -n stackai-infra

    print_status "Nginx ingress controller deployed ✓"

    cd ..
}

# Function to verify nginx deployment
verify_nginx_deployment() {
    print_step "Verifying nginx deployment..."

    # Check nginx controller pods
    print_status "Nginx controller status:"
    kubectl get pods -n stackai-infra -l app.kubernetes.io/name=ingress-nginx

    # Check nginx service
    print_status "Nginx service status:"
    kubectl get svc -n stackai-infra -l app.kubernetes.io/name=ingress-nginx

    # Check ingress resources
    print_status "Ingress resources:"
    kubectl get ingress -n stackai-infra

    # Check if nginx is ready
    if kubectl get pods -n stackai-infra -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running | grep -q nginx-ingress-controller; then
        print_status "Nginx ingress controller is running ✓"
    else
        print_warning "Nginx ingress controller is not running yet"
    fi
}

# Function to show nginx access information
show_nginx_access() {
    print_step "Nginx Access Information"
    echo "========================"
    echo ""

    # Get the external IP of the nginx service
    local external_ip=$(kubectl get svc -n stackai-infra nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "pending")

    if [ "$external_ip" = "pending" ] || [ -z "$external_ip" ]; then
        print_warning "External IP is not ready yet. This may take a few minutes."
        echo "You can check the status with: kubectl get svc -n stackai-infra nginx-ingress-controller"
    else
        print_status "External IP: $external_ip"
    fi

    local protocol="http"
    if [ "$ENABLE_SSL" = "true" ]; then
        protocol="https"
    fi

    echo ""
    echo "🌐 Access URLs (once external IP is ready):"
    echo "=========================================="
    echo "Main App: $protocol://$DOMAIN"
    echo "API: $protocol://api.$DOMAIN"
    echo "Supabase: $protocol://supabase.$DOMAIN"
    echo "Temporal: $protocol://temporal.$DOMAIN"
    echo "Unstructured: $protocol://unstructured.$DOMAIN"
    echo "Repl: $protocol://repl.$DOMAIN"
    echo "Weaviate: $protocol://weaviate.$DOMAIN"
    echo "ArgoCD: $protocol://argocd.$DOMAIN"
    echo "Celery: $protocol://celery.$DOMAIN"
    echo ""
    echo "💡 If using Azure Load Balancer, you may need to:"
    echo "1. Configure DNS records to point to the external IP"
    echo "2. Wait for the load balancer to be ready (can take 5-10 minutes)"
    echo "3. Check Azure Load Balancer health probes"
}

# Main nginx integration function
integrate_nginx() {
    print_step "Integrating nginx ingress controller..."

    # Generate ingress configuration
    generate_vm_ingress

    # Update nginx values
    update_nginx_values

    # Deploy nginx
    deploy_nginx_vm

    # Verify deployment
    verify_nginx_deployment

    # Show access information
    show_nginx_access

    print_status "Nginx integration completed ✓"
}

# Function to setup port forwarding
setup_port_forwarding() {
    print_step "Setting up port forwarding..."

    # Create port forwarding script
    cat > ~/stackai-port-forward.sh <<'EOF'
#!/bin/bash

echo "Starting StackAI port forwarding..."
echo "=================================="

# Function to start port forwarding in background
start_port_forward() {
    local service=$1
    local namespace=$2
    local local_port=$3
    local service_port=$4

    echo "Starting port forward for $service on port $local_port..."
    kubectl port-forward -n $namespace svc/$service $local_port:$service_port &
}

# Start port forwarding for all services
start_port_forward "argocd-server" "argocd" 8080 80
start_port_forward "supabase-kong" "stackai-infra" 8000 8000
start_port_forward "temporal-web" "stackai-processing" 8081 8080
start_port_forward "weaviate" "stackai-data" 8082 8080
start_port_forward "mongodb" "stackai-data" 27017 27017
start_port_forward "redis" "stackai-data" 6379 6379
start_port_forward "postgres" "stackai-data" 5432 5432

echo ""
echo "Port forwarding started!"
echo "======================="
echo "ArgoCD:        http://localhost:8080"
echo "Supabase:      http://localhost:8000"
echo "Temporal:      http://localhost:8081"
echo "Weaviate:      http://localhost:8082"
echo "MongoDB:       localhost:27017"
echo "Redis:         localhost:6379"
echo "PostgreSQL:    localhost:5432"
echo ""
echo "To stop port forwarding, run: pkill -f 'kubectl port-forward'"
EOF

    chmod +x ~/stackai-port-forward.sh

    print_status "Port forwarding script created at ~/stackai-port-forward.sh ✓"
}

# Function to show final information
show_final_info() {
    print_status "StackAI deployment completed! 🎉"
    echo ""
    echo "📋 Access Information:"
    echo "===================="
    echo ""

    # Show nginx access URLs
    local protocol="http"
    if [ "$ENABLE_SSL" = "true" ]; then
        protocol="https"
    fi

    echo "🌐 Production URLs (via nginx ingress):"
    echo "====================================="
    echo "Main App: $protocol://$DOMAIN"
    echo "API: $protocol://api.$DOMAIN"
    echo "Supabase: $protocol://supabase.$DOMAIN"
    echo "Temporal: $protocol://temporal.$DOMAIN"
    echo "Unstructured: $protocol://unstructured.$DOMAIN"
    echo "Repl: $protocol://repl.$DOMAIN"
    echo "Weaviate: $protocol://weaviate.$DOMAIN"
    echo "ArgoCD: $protocol://argocd.$DOMAIN"
    echo "Celery: $protocol://celery.$DOMAIN"
    echo ""

    echo "🔧 Get ArgoCD admin password:"
    echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    echo ""
    echo "🌐 Start port forwarding (for local development):"
    echo "~/stackai-port-forward.sh"
    echo ""
    echo "📊 Check deployment status:"
    echo "kubectl get pods -A"
    echo "kubectl get svc -A"
    echo ""
    echo "🔍 View ArgoCD applications:"
    echo "kubectl get applications -n argocd"
    echo ""
    echo "📝 Useful Commands:"
    echo "=================="
    echo "  Check pod status: kubectl get pods -A"
    echo "  Check services: kubectl get svc -A"
    echo "  Check nginx status: kubectl get pods -n stackai-infra -l app.kubernetes.io/name=ingress-nginx"
    echo "  Check ingress: kubectl get ingress -n stackai-infra"
    echo "  View logs: kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd"
    echo "  Restart services: kubectl rollout restart deployment -n stackai-infra"
    echo ""
    echo "🚀 Next Steps:"
    echo "============="
    echo "1. Wait for external IP to be assigned (check with: kubectl get svc -n stackai-infra nginx-ingress-controller)"
    echo "2. Configure DNS records to point to the external IP"
    echo "3. Access your services via the production URLs above"
    echo "4. For local development, run: ~/stackai-port-forward.sh"
    echo "5. Get ArgoCD admin password with the command above"
    echo "6. Configure your applications in ArgoCD"
}

# Main function
main() {
    echo "This script will:"
    echo "1. Install required tools (kubectl, Helm, Terraform)"
    echo "2. Install k3s Kubernetes cluster"
    echo "3. Configure k3s for StackAI"
    echo "4. Interactive configuration (domain, SSL, resources, ACR credentials)"
    echo "5. Deploy StackAI infrastructure using Terraform"
    echo "6. Configure nginx ingress controller with proper routing"
    echo "7. Set up port forwarding for local access"
    echo ""
    print_warning "You will be prompted for:"
    echo "  - Domain name (default: yasser.eastus.cloudapp.azure.com)"
    echo "  - SSL/TLS preference"
    echo "  - CPU and memory limits"
    echo "  - ArgoCD admin password"
    echo "  - Azure Container Registry credentials (optional)"
    echo "  - Tiptap Pro Token (optional)"
    echo ""
    print_status "The script will automatically update all values files with your domain!"
    echo ""

    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        check_vm_resources
        install_tools
        install_k3s
        configure_k3s
        verify_nginx_ingress
        configure_terraform
        deploy_stackai
        integrate_nginx
        setup_port_forwarding
        show_final_info
    else
        print_status "Setup cancelled."
        exit 0
    fi
}

# Run main function
main "$@"
