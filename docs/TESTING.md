# Testing Guide for ansible.mcp_builder Collection

## Overview

This collection uses a comprehensive testing framework including:

- **Ansible Lint**: Code quality and best practices
- **Sanity Tests**: Ansible collection standards compliance
- **Molecule Integration Tests**: End-to-end testing with pre-built container images

## Architecture

┌─────────────────────────────────────────────────┐
│ Pre-built Test Base Image (GHCR) │
│ - UBI9 base (Python 3.11) │
│ - System dependencies from bindep.txt │
│ - Ansible + Molecule installed │
└─────────────────────────────────────────────────┘
↓
┌─────────────────────────────────────────────────┐
│ Podman launches container │
│ Mounts collection code │
└─────────────────────────────────────────────────┘
↓
┌─────────────────────────────────────────────────┐
│ Molecule runs inside container │
│ 1. Prepare: Install collection │
│ 2. Converge: Install MCP servers (installs deps) │
│ 3. Verify: Validate installation & functionality │
└─────────────────────────────────────────────────┘

## Prerequisites

### Local Development

```bash
# Required software
- Podman or Docker
- Python 3.9+
- Git

# Install Python dependencies
pip install -r requirements-test.txt
```

## Running Tests Locally

### 1. Build the Test Base Image (First Time Only)

```bash
# Build locally
podman build -f tools/Containerfile -t localhost/mcp-builder-test-base:local .

# Or pull from GHCR (if already built)
podman pull ghcr.io/ansible/mcp-builder-test-base:latest
```

### 2. Run Ansible Lint

```bash
# From repo root
ansible-lint

# Check specific paths
ansible-lint roles/
ansible-lint playbooks/
```

### 3. Run Sanity Tests

```bash
# Sanity tests must run from within the collection path structure
# Set up the collection path
mkdir -p /tmp/ansible_collections/ansible
ln -s $(pwd) /tmp/ansible_collections/ansible/mcp_builder

# Run sanity tests
cd /tmp/ansible_collections/ansible/mcp_builder
ansible-test sanity --docker default -v
```

### 4. Run Molecule Integration Tests

```bash
# Full test suite (dependency, syntax, create, prepare, converge, verify, destroy)
cd extensions
molecule test -s integration

# Step-by-step for debugging
molecule create -s integration      # Create container from pre-built image
molecule prepare -s integration     # Install collection and dependencies
molecule converge -s integration    # Install all MCP servers (installs Go, Node.js, uv)
molecule verify -s integration      # Validate installation & mcp_manage script
molecule destroy -s integration     # Clean up

# Keep container running for debugging
molecule test -s integration --destroy never

# Login to test container for manual debugging
molecule login -s integration

# Note: The integration test installs all 6 MCP servers:
# - github-mcp-server
# - azure-mcp-server
# - aws-iam-mcp-server
# - aws-ccapi-mcp-server
# - aws-cdk-mcp-server
# - aws-core-mcp-server
```

### 5. Run Individual Test Scenarios

```bash
cd extensions

# Test manifest generation
molecule test -s common_manifest

# Test language-specific scenarios
molecule test -s language_selection

# Test server selection
molecule test -s server_selection
```

## Debugging Failed Tests

### View Logs

```bash
# Molecule logs
cat extensions/molecule/integration/*.log

# Container logs
podman ps -a
podman logs mcp-test-instance
```

### Interactive Debugging

```bash
# Start container and login
cd extensions
molecule create -s integration
molecule login -s integration

# Inside container, manually test
ls -la /opt/mcp/
cat /opt/mcp/mcpservers.json
/usr/local/bin/mcp_manage list
go version
node --version
```

### Common Issues

#### Issue: Image not found

```bash
# Solution: Build or pull the image
podman build -f tools/Containerfile -t localhost/mcp-builder-test-base:local .
# Or pull from GHCR
podman pull ghcr.io/ansible/mcp-builder-test-base:latest
```

#### Issue: Permission denied in container

```bash
# Solution: Check SELinux context on mounted volumes
# Add :Z to volume mount in molecule.yml
volumes:
  - ${PWD}:/workspace:Z
```

#### Issue: Tests pass locally but fail in CI

```bash
# Check:
1. Image is pushed to GHCR with correct tag
2. Workflow has correct permissions (packages:write)
3. Reusable workflow is using correct image tag
4. Python/Ansible version matrix is compatible
```

#### Issue: Molecule driver not found

```bash
# Solution: Ensure molecule-plugins[podman] is installed
pip install molecule-plugins[podman]
# Or use tox which installs it automatically
```

## CI/CD Pipeline

Tests run automatically on:

### Triggers

- **Pull Requests**: All tests run (lint, sanity, integration)
- **Push to main/devel**: All tests + image build and push to GHCR
- **Manual**: `workflow_dispatch` for on-demand testing

### Workflow Jobs

1. **ansible-lint**: Runs `ansible-lint` on all collection content
2. **sanity**: Runs sanity tests using reusable `ansible-content-actions` workflow
3. **unit-galaxy**: Runs unit tests using reusable `ansible-content-actions` workflow
4. **build-test-image**: Builds and pushes test base image to GHCR (on PRs and main/devel)
5. **integration**: Runs Molecule integration tests using reusable `ansible-content-actions` workflow
   - Tests multiple Python/Ansible version combinations automatically
   - Uses pre-built test image from GHCR
   - Runs all Molecule scenarios
6. **all_green**: Verifies all tests passed successfully

### Test Image Build

The test base image (`ghcr.io/ansible/mcp-builder-test-base`) is built from `tools/Containerfile`:

- Base: `registry.access.redhat.com/ubi9/ubi:latest` (Python 3.11)
- System packages: Installed dynamically from `bindep.txt` using `bindep` tool
- NodeSource: Pre-configured during image build (repository setup, no Node.js installed)
- Runtime dependencies: Go, Node.js, and `uv` are installed by the collection during `converge`
- Ansible/Molecule: Pre-installed for testing

### Collection Installation

The collection is installed to `/tmp/ansible_collections/ansible/mcp_builder` inside the test container during the `prepare` step. This path is configured in `molecule.yml` via `ANSIBLE_COLLECTIONS_PATH` environment variable. The collection is copied from the mounted workspace (`/workspace/ansible.mcp_builder`) to ensure the latest code is tested.

## Test Coverage

- [x] Ansible-lint configuration and passing
- [x] Sanity tests configured and passing
- [x] Integration tests for all 6 MCP servers
- [x] Manifest file generation validation
- [x] mcp_manage script functionality (list, info, run)
- [x] CI/CD pipeline with GitHub Actions
- [x] Tests run automatically on pull requests
- [x] Pre-built test image with NodeSource pre-configured
- [x] Runtime dependency installation (Go, Node.js, uv)

### Test Coverage Goals

- [x] All roles have passing integration tests
- [x] All MCP servers can be installed successfully
- [x] Manifest generation is validated
- [x] mcp_manage script functionality is tested

## Resources

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Ansible Test Documentation](https://docs.ansible.com/ansible/latest/dev_guide/testing.html)
- [Ansible Lint Rules](https://ansible-lint.readthedocs.io/)
