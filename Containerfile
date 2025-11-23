FROM registry.access.redhat.com/ubi9/ubi:latest

LABEL org.opencontainers.image.source=https://github.com/ansible/ansible.mcp_builder
LABEL org.opencontainers.image.authors="Ansible Content Team"
LABEL org.opencontainers.image.vendor="Red Hat"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.description="Test base image for ansible.mcp_builder collection"

ENV CI=1
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=/go
ENV GOCACHE=/tmp/go-cache
ENV PATH=/root/.local/bin:/usr/local/go/bin:${GOPATH}/bin:${PATH}

USER root
WORKDIR /workspace

RUN dnf install -y --allowerasing \
    python3 \
    python3-pip \
    python3-devel \
    python3-dnf \
    git \
    gcc \
    make \
    wget \
    curl \
    jq \
    podman \
    tar \
    libicu \
    && dnf clean all

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    ansible-core>=2.14 \
    molecule \
    molecule-plugins[podman] \
    pytest \
    pytest-ansible

RUN mkdir -p /opt/mcp /workspace /go /tmp/go-cache

RUN ansible --version && \
    python3 --version

CMD ["/bin/bash"]
