FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        wget \
        git \
        jq \
        unzip \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        apt-transport-https \
        build-essential \
        python3 \
        python3-pip \
        nodejs \
        npm \
    && apt-get autoremove -y && apt-get clean -y

# Install yq (YAML processor) from official source
RUN ARCH=$(dpkg --print-architecture) \
    && wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${ARCH} \
    && chmod +x /usr/local/bin/yq

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl

# Install kind (Kubernetes in Docker)
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then KIND_ARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then KIND_ARCH="arm64"; else KIND_ARCH="amd64"; fi \
    && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-${KIND_ARCH} \
    && chmod +x ./kind \
    && mv ./kind /usr/local/bin/kind

# Install k9s for better k8s management
RUN curl -sS https://webinstall.dev/k9s | bash \
    && mv ~/.local/bin/k9s /usr/local/bin/

# Install ArgoCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

# Install kubectx and kubens for easier context switching
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx \
    && ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx \
    && ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Stern for log aggregation
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then STERN_ARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then STERN_ARCH="arm64"; else STERN_ARCH="amd64"; fi \
    && STERN_VERSION="1.30.0" \
    && curl -L https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_${STERN_ARCH}.tar.gz -o stern.tar.gz \
    && tar xzf stern.tar.gz \
    && mv stern /usr/local/bin/ \
    && rm stern.tar.gz

# Install Telepresence for local development
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then TEL_ARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then TEL_ARCH="arm64"; else TEL_ARCH="amd64"; fi \
    && curl -fL https://app.getambassador.io/download/tel2oss/releases/download/v2.17.0/telepresence-linux-${TEL_ARCH} -o /usr/local/bin/telepresence \
    && chmod +x /usr/local/bin/telepresence

# Create directories for k8s configs
RUN mkdir -p /home/vscode/.kube \
    && mkdir -p /home/vscode/.config/helm \
    && mkdir -p /home/vscode/.cache/helm \
    && mkdir -p /home/vscode/.local/share/helm \
    && chown -R vscode:vscode /home/vscode/.kube \
    && chown -R vscode:vscode /home/vscode/.config \
    && chown -R vscode:vscode /home/vscode/.cache \
    && chown -R vscode:vscode /home/vscode/.local

# Set up shell aliases and environment for vscode user
USER vscode
RUN echo 'alias k=kubectl' >> ~/.bashrc \
    && echo 'alias kgp="kubectl get pods"' >> ~/.bashrc \
    && echo 'alias kgs="kubectl get svc"' >> ~/.bashrc \
    && echo 'alias kgn="kubectl get nodes"' >> ~/.bashrc \
    && echo 'alias kaf="kubectl apply -f"' >> ~/.bashrc \
    && echo 'alias kdel="kubectl delete"' >> ~/.bashrc \
    && echo 'alias klog="kubectl logs"' >> ~/.bashrc \
    && echo 'alias kexec="kubectl exec -it"' >> ~/.bashrc \
    && echo 'alias argocd-port-forward="kubectl port-forward svc/argocd-server -n argocd 8080:443"' >> ~/.bashrc \
    && echo 'export KUBECONFIG=/home/vscode/.kube/config' >> ~/.bashrc

# Install helm plugins
USER root
RUN helm plugin install https://github.com/databus23/helm-diff \
    && helm plugin install https://github.com/jkroepke/helm-secrets

USER vscode
