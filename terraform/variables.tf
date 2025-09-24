variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "argocd_admin_password" {
  description = "ArgoCD admin password (leave empty to use generated password)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "domain" {
  description = "Domain for local development"
  type        = string
  default     = "localhost"
}

variable "enable_ssl" {
  description = "Enable SSL/TLS for services"
  type        = bool
  default     = false
}

variable "resource_limits" {
  description = "Resource limits for development environment"
  type = object({
    cpu_limit    = string
    memory_limit = string
  })
  default = {
    cpu_limit    = "500m"
    memory_limit = "512Mi"
  }
}

variable "acr_username" {
  description = "Azure Container Registry username"
  type        = string
  default     = ""
  sensitive   = true
}

variable "acr_password" {
  description = "Azure Container Registry password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tiptap_pro_token" {
  description = "Tiptap Pro Token"
  type        = string
  default     = ""
}
