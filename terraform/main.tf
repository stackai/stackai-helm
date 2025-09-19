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
