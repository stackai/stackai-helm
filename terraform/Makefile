.PHONY: help init plan apply destroy status port-forward clean

# Default target
help: ## Show this help message
	@echo "StackAI Local Infrastructure Management"
	@echo "======================================"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform
	terraform init

plan: ## Plan Terraform deployment
	terraform plan

apply: ## Apply Terraform configuration
	terraform apply

apply-auto: ## Apply Terraform configuration with auto-approve
	terraform apply -auto-approve

destroy: ## Destroy all resources
	terraform destroy

status: ## Check infrastructure status
	@./scripts/status.sh

port-forward: ## Start port forwarding for all services
	@./scripts/port-forward.sh

setup: ## Complete setup (init + apply)
	@./scripts/setup.sh

setup-acr: ## Setup Azure Container Registry authentication
	@./scripts/setup-acr-auth.sh

clean: ## Clean up local files
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
	rm -f crash.log

# Development helpers
logs-argocd: ## View ArgoCD logs
	kubectl logs -l app.kubernetes.io/name=argocd-server -n argocd -f

logs-supabase: ## View Supabase logs
	kubectl logs -l app.kubernetes.io/component=auth -n stackai-infra -f

logs-temporal: ## View Temporal logs
	kubectl logs -l app.kubernetes.io/component=server -n stackai-processing -f

restart-all: ## Restart all deployments
	kubectl rollout restart deployment -n stackai-infra
	kubectl rollout restart deployment -n stackai-data
	kubectl rollout restart deployment -n stackai-processing

# ArgoCD helpers
argocd-password: ## Get ArgoCD admin password
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
	@echo ""

argocd-sync: ## Sync all ArgoCD applications
	@kubectl patch application stackai-infrastructure -n argocd --type merge -p '{"operation":{"sync":{"syncStrategy":{"force":true}}}}'
	@kubectl patch application stackai-applications -n argocd --type merge -p '{"operation":{"sync":{"syncStrategy":{"force":true}}}}'

# Quick access URLs
urls: ## Show access URLs
	@echo "StackAI Services Access URLs:"
	@echo "============================"
	@echo "Services Overview: http://localhost"
	@echo "ArgoCD:            http://argocd.localhost"
	@echo "Supabase:          http://supabase.localhost"
	@echo "Temporal Web:      http://temporal.localhost"
	@echo "Weaviate:          http://weaviate.localhost"
	@echo ""
	@echo "Database Connections:"
	@echo "MongoDB:       localhost:27017"
	@echo "Redis:         localhost:6379"
	@echo "PostgreSQL:    localhost:5432"
