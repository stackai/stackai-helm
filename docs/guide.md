# StackAI DevContainer Troubleshooting Guide

## 🚨 Common Issues and Solutions

### 1. Container Won't Start

**Symptoms:**

- VS Code fails to open the devcontainer
- Docker errors during container build

**Solutions:**

```bash
# Check Docker is running
docker info

# Clean up Docker resources
docker system prune -f

# Rebuild container without cache
docker build --no-cache .devcontainer/

# Reset VS Code devcontainer
# Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
```

### 2. Kind Cluster Creation Fails

**Symptoms:**

- Setup script fails at cluster creation
- `kind create cluster` errors

**Solutions:**

```bash
# Delete existing cluster
kind delete cluster --name stackai-dev

# Check Docker resources
docker stats

# Increase Docker memory/CPU limits in Docker Desktop
# Recommended: 8GB RAM, 4 CPUs

# Recreate cluster
bash .devcontainer/setup.sh
```

### 3. Services Won't Deploy

**Symptoms:**

- Pods stuck in `Pending` or `CrashLoopBackOff`
- Helm install failures

**Solutions:**

```bash
# Check cluster resources
kubectl top nodes
kubectl describe nodes

# Check pod events
kubectl get events -A --sort-by='.lastTimestamp'

# Check specific pod
kubectl describe pod <pod-name> -n <namespace>

# Check persistent volumes
kubectl get pv,pvc -A

# Restart deployments
kubectl rollout restart deployment -n stackai-data
kubectl rollout restart deployment -n stackai-infra
```

### 4. ArgoCD Not Accessible

**Symptoms:**

- ArgoCD UI not loading at localhost:8080
- Port forwarding fails

**Solutions:**

```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# Restart ArgoCD
kubectl rollout restart deployment/argocd-server -n argocd

# Manual port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 5. Supabase Components Not Starting

**Symptoms:**

- Supabase Studio not accessible
- Database connection errors

**Solutions:**

```bash
# Check Supabase pods
kubectl get pods -n stackai-infra

# Check database is ready
kubectl logs -l app.kubernetes.io/component=db -n stackai-infra

# Check init containers
kubectl describe pod -l app.kubernetes.io/component=auth -n stackai-infra

# Restart Supabase
helm upgrade supabase ./helm/infra/supabase \
    --namespace stackai-infra \
    --values dev-values/supabase-dev.yaml
```

### 6. Temporal Workflow Engine Issues

**Symptoms:**

- Temporal Web UI not accessible
- Workflow execution failures
- Database connection errors

**Solutions:**

```bash
# Check Temporal pods
kubectl get pods -n stackai-processing

# Check Temporal server logs
kubectl logs -l app.kubernetes.io/component=server -n stackai-processing

# Check database connectivity (uses Supabase PostgreSQL)
kubectl logs -l app.kubernetes.io/component=db -n stackai-infra

# Restart Temporal
helm upgrade temporal ./helm/app/temporal \
    --namespace stackai-processing \
    --values dev-values/temporal-dev.yaml

# Test Temporal connectivity
kubectl run -it --rm temporal-test --image=temporalio/tctl --restart=Never -- \
  tctl --address temporal-server.stackai-processing.svc.cluster.local:7233 cluster health
```

### 7. Unstructured API Issues

**Symptoms:**

- API not responding
- Document processing failures
- High memory usage

**Solutions:**

```bash
# Check Unstructured pods
kubectl get pods -n stackai-processing

# Check API health
curl http://localhost:8082/general/v0/general

# View resource usage
kubectl top pods -n stackai-processing

# Check logs
./scripts/logs.sh unstructured -f

# Restart Unstructured
kubectl rollout restart deployment/unstructured -n stackai-processing

# Test with a simple document
curl -X POST http://localhost:8082/general/v0/general \
  -F 'files=@test.txt' \
  -H 'Content-Type: multipart/form-data'
```

### 8. Storage Issues

**Symptoms:**

- Pods can't mount volumes
- PVC stuck in `Pending`

**Solutions:**

```bash
# Check storage class
kubectl get storageclass

# Check PVCs
kubectl get pvc -A

# Delete and recreate PVCs
kubectl delete pvc --all -n stackai-data
kubectl delete pvc --all -n stackai-infra

# Redeploy services
bash .devcontainer/start-services.sh
```

### 9. Port Conflicts

**Symptoms:**

- Port forwarding fails
- "Port already in use" errors

**Solutions:**

```bash
# Check what's using the port
lsof -i :8080
netstat -tulpn | grep :8080

# Kill process using the port
kill -9 <PID>

# Use different ports
kubectl port-forward svc/argocd-server -n argocd 8081:443
```

### 10. DNS Resolution Issues

**Symptoms:**

- Services can't reach each other
- DNS lookup failures

**Solutions:**

```bash
# Check CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Test DNS from a pod
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup kubernetes.default

# Restart CoreDNS
kubectl rollout restart deployment/coredns -n kube-system
```

### 11. Resource Constraints

**Symptoms:**

- Pods evicted
- Out of memory errors
- Slow performance

**Solutions:**

```bash
# Check resource usage
kubectl top nodes
kubectl top pods -A

# Reduce resource requests in dev-values/*.yaml
# Example for MongoDB:
resources:
  requests:
    memory: 128Mi
    cpu: 50m
  limits:
    memory: 256Mi
    cpu: 200m

# Apply changes
helm upgrade mongodb ./helm/infra/mongo \
    --namespace stackai-data \
    --values dev-values/mongodb-dev.yaml
```

### 12. Image Pull Issues

**Symptoms:**

- `ImagePullBackOff` errors
- Cannot pull container images

**Solutions:**

```bash
# Check image exists
docker pull <image-name>

# Check node connectivity
kubectl get nodes -o wide

# Use local images (for development)
kind load docker-image <image-name> --name stackai-dev

# Check image pull secrets
kubectl get secrets -A | grep regcred
```

## 🔧 Diagnostic Commands

### Quick Health Check

```bash
# Run the status script
./scripts/check-services.sh

# Check all pods
kubectl get pods -A

# Check cluster info
kubectl cluster-info
```

### Detailed Diagnostics

```bash
# Resource usage
kubectl top nodes
kubectl top pods -A

# Events (recent issues)
kubectl get events -A --sort-by='.lastTimestamp' | tail -20

# Storage
kubectl get pv,pvc -A

# Network
kubectl get svc,endpoints -A
```

### Logs Analysis

```bash
# Use the logs script
./scripts/logs.sh all -f

# Or specific service
./scripts/logs.sh supabase --since 1h

# ArgoCD applications
kubectl get applications -n argocd
kubectl describe application mongodb -n argocd
```

## 🔄 Reset Procedures

### Soft Reset (Keep Cluster)

```bash
# Delete applications
kubectl delete applications --all -n argocd

# Delete deployments
kubectl delete deployment --all -n stackai-data
kubectl delete deployment --all -n stackai-infra
kubectl delete deployment --all -n stackai-processing

# Redeploy
bash .devcontainer/start-services.sh
```

### Hard Reset (Recreate Everything)

```bash
# Delete cluster
kind delete cluster --name stackai-dev

# Clean Docker
docker system prune -f

# Recreate environment
bash .devcontainer/setup.sh
bash .devcontainer/start-services.sh
```

### Nuclear Reset (Complete Clean)

```bash
# Stop VS Code devcontainer
# Delete container volumes
docker volume prune -f

# Remove devcontainer
docker container prune -f

# Rebuild devcontainer in VS Code
# Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
```

## 🔄 Service-Specific Troubleshooting

### Temporal Workflow Engine

```bash
# Check Temporal server health
kubectl run -it --rm temporal-test --image=temporalio/tctl --restart=Never -- \
  tctl --address temporal-server.stackai-processing.svc.cluster.local:7233 cluster health

# List workflows
kubectl run -it --rm temporal-test --image=temporalio/tctl --restart=Never -- \
  tctl --address temporal-server.stackai-processing.svc.cluster.local:7233 workflow list

# Check database connection
kubectl logs -l app.kubernetes.io/component=server -n stackai-processing | grep -i "database\|postgres\|connection"

# Temporal Web UI access
kubectl port-forward svc/temporal-web -n stackai-processing 8088:8088
# Then visit http://localhost:8088
```

### Unstructured Document Processing

```bash
# Test API health
curl -X GET http://localhost:8082/general/v0/general

# Test document processing with a simple file
echo "Hello World" > test.txt
curl -X POST http://localhost:8082/general/v0/general \
  -F 'files=@test.txt' \
  -H 'Content-Type: multipart/form-data'

# Check memory usage (Unstructured can be memory-intensive)
kubectl top pods -n stackai-processing

# Check for OOM kills
kubectl get events -n stackai-processing | grep -i "killed\|oom"

# Scale resources if needed
kubectl patch deployment unstructured -n stackai-processing -p '{"spec":{"template":{"spec":{"containers":[{"name":"unstructured","resources":{"limits":{"memory":"2Gi","cpu":"1000m"}}}]}}}}'
```

### Service Integration Testing

```bash
# Test MongoDB connection
kubectl run -it --rm mongo-test --image=mongo --restart=Never -- \
  mongosh --host mongodb.stackai-data.svc.cluster.local:27017 -u admin -p stackai-dev-password

# Test Redis connection
kubectl run -it --rm redis-test --image=redis --restart=Never -- \
  redis-cli -h redis.stackai-data.svc.cluster.local ping

# Test Weaviate connection
kubectl run -it --rm weaviate-test --image=curlimages/curl --restart=Never -- \
  curl -X GET http://weaviate.stackai-data.svc.cluster.local:8080/v1/meta

# Test Supabase API
kubectl run -it --rm supabase-test --image=curlimages/curl --restart=Never -- \
  curl -X GET http://supabase-kong.stackai-infra.svc.cluster.local:8000/health
```

## 📊 Monitoring Commands

### Real-time Monitoring

```bash
# Interactive dashboard
k9s

# Watch pods
watch kubectl get pods -A

# Follow logs
./scripts/logs.sh all -f
```

### Performance Monitoring

```bash
# Resource usage
kubectl top nodes
kubectl top pods -A

# Describe nodes
kubectl describe nodes

# Check events
kubectl get events -A --watch
```

## 🆘 Getting Help

### Useful Resources

- [Kubernetes Troubleshooting](https://kubernetes.io/docs/tasks/debug-application-cluster/)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [ArgoCD Troubleshooting](https://argo-cd.readthedocs.io/en/stable/operator-manual/troubleshooting/)
- [Supabase Self-Hosting](https://supabase.com/docs/guides/hosting/overview)

### Debug Information to Collect

When reporting issues, include:

```bash
# System info
kubectl version
docker version
kind version

# Cluster state
kubectl get nodes -o wide
kubectl get pods -A
kubectl get events -A --sort-by='.lastTimestamp' | tail -20

# Resource usage
kubectl top nodes
kubectl top pods -A

# Specific service logs
./scripts/logs.sh <service> --since 1h
```

### Support Channels

1. Check the logs first: `./scripts/logs.sh all`
2. Review this troubleshooting guide
3. Search existing issues in the repository
4. Create a new issue with debug information

---

**Remember**: Most issues can be resolved by restarting services or recreating the cluster. Don't hesitate to use the reset procedures above! 🚀
