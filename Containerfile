# Base image - UBI9 for Red Hat compatibility
FROM registry.access.redhat.com/ubi9/ubi:latest

LABEL org.opencontainers.image.source=https://github.com/ansible/ansible.mcp_builder
LABEL org.opencontainers.image.authors="Ansible Content Team"
LABEL org.opencontainers.image.vendor="Red Hat"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.description="Test base image for ansible.mcp_builder collection"

# Environment setup
ENV CI=1
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=/go
ENV GOCACHE=/tmp/go-cache
ENV PATH=/root/.local/bin:/usr/local/go/bin:${GOPATH}/bin:${PATH}

USER root
WORKDIR /workspace

# Install system dependencies
RUN dnf install -y --allowerasing \
    python3 \
    python3-pip \
    python3-devel \
    git \
    gcc \
    make \
    wget \
    curl \
    jq \
    podman \
    && dnf clean all

# Install Go (required for some MCP servers)
RUN GO_VERSION=1.21.5 && \
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Install Node.js and npm (required for TypeScript MCP servers)
RUN curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - && \
    dnf install -y nodejs && \
    dnf clean all

# Install uv (required for PyPI MCP servers)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv ~/.cargo/bin/uv /usr/local/bin/uv || \
    mv ~/.local/bin/uv /usr/local/bin/uv || true && \
    uv --version

# Install Python packages
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    ansible-core>=2.14 \
    molecule \
    molecule-plugins[podman] \
    ansible-lint \
    pytest \
    pytest-ansible

# Create necessary directories
RUN mkdir -p /opt/mcp /workspace /go /tmp/go-cache

# Verify installations
RUN ansible --version && \
    go version && \
    node --version && \
    npm --version && \
    uv --version && \
    python3 --version

CMD ["/bin/bash"]
