# StackAI VM Kubernetes Deployment Guide

This guide will help you deploy StackAI on an Azure VM using a local Kubernetes cluster (k3s).

## Prerequisites

### Azure VM Requirements

- **OS**: Ubuntu 20.04 LTS or later
- **Size**: At least Standard_D4s_v3 (4 vCPUs, 16 GB RAM)
- **Storage**: At least 100 GB SSD
- **Network**: Public IP with open ports 80, 443, 8080-8082

### VM Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install basic tools
sudo apt install -y curl wget git unzip
```

## Quick Start

### Option 1: Automated Setup

```bash
# Clone the repository
git clone https://github.com/stackai/stackai-helm.git
cd stackai-helm

# Run the automated setup script
./scripts/vm-k8s-setup.sh
```

### Option 2: Manual Setup

#### Step 1: Install Required Tools

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

#### Step 2: Install k3s Kubernetes

```bash
# Install k3s
curl -sfL https://get.k3s.io | sh -

# Configure kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Test connection
kubectl get nodes
```

#### Step 3: Configure k3s for StackAI

```bash
# Create k3s configuration
sudo mkdir -p /etc/rancher/k3s
sudo tee /etc/rancher/k3s/config.yaml > /dev/null <<EOF
write-kubeconfig-mode: "0644"
disable:
  - traefik  # We'll use nginx ingress instead
  - servicelb
kube-apiserver-arg:
  - "enable-admission-plugins=NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook"
EOF

# Restart k3s
sudo systemctl restart k3s
```

#### Step 4: Verify Nginx Configuration

```bash
# Note: Nginx Ingress Controller is already configured in your Terraform
# It includes:
# - Custom nginx ingress controller
# - Service routing for all StackAI services
# - LoadBalancer service type
# - CORS and security headers
# - Rate limiting and proxy configuration

# The nginx controller will be deployed automatically with Terraform
```

#### Step 5: Configure and Deploy StackAI

```bash
cd terraform

# Copy terraform variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars for VM deployment
nano terraform.tfvars
```

Update `terraform.tfvars`:

```hcl
kubeconfig_path = "~/.kube/config"
domain = "localhost"
enable_ssl = false
resource_limits = {
  cpu_limit    = "1000m"
  memory_limit = "2Gi"
}
argocd_admin_password = "stackai-dev-argocd-password"
acr_username = ""
acr_password = ""
```

Deploy StackAI:

```bash
# Initialize and deploy
terraform init
terraform plan
terraform apply
```

## Accessing Services

### Port Forwarding Setup

Create a port forwarding script:

```bash
cat > ~/stackai-port-forward.sh <<'EOF'
#!/bin/bash

echo "Starting StackAI port forwarding..."

# Start port forwarding for all services
kubectl port-forward -n argocd svc/argocd-server 8080:80 &
kubectl port-forward -n stackai-infra svc/supabase-kong 8000:8000 &
kubectl port-forward -n stackai-processing svc/temporal-web 8081:8080 &
kubectl port-forward -n stackai-data svc/weaviate 8082:8080 &
kubectl port-forward -n stackai-data svc/mongodb 27017:27017 &
kubectl port-forward -n stackai-data svc/redis 6379:6379 &
kubectl port-forward -n stackai-data svc/postgres 5432:5432 &

echo "Port forwarding started!"
echo "ArgoCD: http://localhost:8080"
echo "Supabase: http://localhost:8000"
echo "Temporal: http://localhost:8081"
echo "Weaviate: http://localhost:8082"
EOF

chmod +x ~/stackai-port-forward.sh
```

### Start Port Forwarding

```bash
~/stackai-port-forward.sh
```

### Access URLs

- **ArgoCD**: <http://localhost:8080>
- **Supabase**: <http://localhost:8000>
- **Temporal**: <http://localhost:8081>
- **Weaviate**: <http://localhost:8082>

### Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

## Architecture Overview

### Namespaces

- `argocd` - ArgoCD for GitOps
- `stackai-infra` - Infrastructure components (nginx, supabase)
- `stackai-data` - Data stores (mongodb, redis, postgres, weaviate)
- `stackai-processing` - Processing services (temporal, celery, repl, stackend, stackweb)

### Components

#### Infrastructure

- **Nginx Ingress Controller** - Load balancer and ingress
- **ArgoCD** - GitOps continuous delivery
- **Supabase** - Backend-as-a-Service (auth, db, api)

#### Data Stores

- **MongoDB** - Document database
- **Redis** - In-memory cache
- **PostgreSQL** - Relational database for Temporal
- **Weaviate** - Vector database

#### Applications

- **Temporal** - Workflow orchestration engine
- **Celery** - Task queue
- **Repl** - Code execution service
- **Stackend** - Backend API
- **Stackweb** - Frontend application
- **Unstructured** - Document processing

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
# Check all pods
kubectl get pods -A

# Check all services
kubectl get svc -A

# Check ingress
kubectl get ingress -A
```

### View Logs

```bash
# ArgoCD logs
kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd

# Supabase logs
kubectl logs -l app.kubernetes.io/component=auth -n stackai-infra

# Temporal logs
kubectl logs -l app.kubernetes.io/component=server -n stackai-processing
```

### Restart Services

```bash
# Restart all deployments in a namespace
kubectl rollout restart deployment -n stackai-infra
kubectl rollout restart deployment -n stackai-data
kubectl rollout restart deployment -n stackai-processing
```

### Check Resource Usage

```bash
# Check node resources
kubectl top nodes

# Check pod resources
kubectl top pods -A
```

## Production Considerations

### Security

1. **Change default passwords** in all services
2. **Enable SSL/TLS** for external access
3. **Configure network policies** for pod-to-pod communication
4. **Use secrets management** for sensitive data

### Scaling

```bash
# Scale deployments
kubectl scale deployment stackend -n stackai-processing --replicas=3
kubectl scale deployment stackweb -n stackai-processing --replicas=3
```

### Backup

```bash
# Backup persistent volumes
kubectl get pv
kubectl get pvc -A
```

## External Access (Optional)

### Configure Domain Access

If you want to access services via domain names:

1. **Get VM Public IP**:

```bash
curl ifconfig.me
```

2. **Configure DNS**:
Point your domain to the VM's public IP:

- `your-domain.com` → VM Public IP
- `argocd.your-domain.com` → VM Public IP
- `supabase.your-domain.com` → VM Public IP

3. **Update Ingress Configuration**:
Update the nginx ingress configuration to use your domain instead of localhost.

### SSL/TLS Setup

```bash
# Install cert-manager for automatic SSL certificates
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

## Cleanup

### Stop Services

```bash
# Stop port forwarding
pkill -f 'kubectl port-forward'

# Stop k3s
sudo systemctl stop k3s
sudo systemctl disable k3s
```

### Remove StackAI

```bash
cd terraform
terraform destroy
```

### Uninstall k3s

```bash
# Uninstall k3s
/usr/local/bin/k3s-uninstall.sh
```

## Support

### Common Issues

1. **Pods not starting**: Check resource limits and node capacity
2. **Services not accessible**: Verify port forwarding and ingress configuration
3. **ArgoCD sync issues**: Check application status and logs

### Useful Commands

```bash
# Check cluster info
kubectl cluster-info

# Check events
kubectl get events -A --sort-by='.lastTimestamp'

# Check resource quotas
kubectl describe quota -A

# Check persistent volumes
kubectl get pv,pvc -A
```

## Cost Optimization

### Resource Management

- Monitor resource usage with `kubectl top`
- Adjust resource limits based on actual usage
- Use node affinity for better resource distribution

### Storage Optimization

- Use appropriate storage classes
- Implement backup strategies
- Monitor storage usage
