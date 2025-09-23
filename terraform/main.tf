terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Configure the kubectl Provider
provider "kubectl" {
  config_path = "~/.kube/config"
}

# Create namespaces
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "stackai_infra" {
  metadata {
    name = "stackai-infra"
  }
}

resource "kubernetes_namespace" "stackai_data" {
  metadata {
    name = "stackai-data"
  }
}

resource "kubernetes_namespace" "stackai_processing" {
  metadata {
    name = "stackai-processing"
  }
}

# Create Azure Container Registry secret for image pulling
resource "kubernetes_secret" "acr_secret" {
  for_each = toset([
    kubernetes_namespace.argocd.metadata[0].name,
    kubernetes_namespace.stackai_infra.metadata[0].name,
    kubernetes_namespace.stackai_data.metadata[0].name,
    kubernetes_namespace.stackai_processing.metadata[0].name
  ])

  metadata {
    name      = "acr-secret"
    namespace = each.value
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "stackai.azurecr.io" = {
          username = var.acr_username
          password = var.acr_password
          auth     = base64encode("${var.acr_username}:${var.acr_password}")
        }
      }
    })
  }

  depends_on = [
    kubernetes_namespace.argocd,
    kubernetes_namespace.stackai_infra,
    kubernetes_namespace.stackai_data,
    kubernetes_namespace.stackai_processing
  ]
}
