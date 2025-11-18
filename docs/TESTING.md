# Testing Guide for ansible.mcp_builder Collection

## Overview

This collection uses a comprehensive testing framework including:

- **Ansible Lint**: Code quality and best practices
- **Sanity Tests**: Ansible collection standards compliance
- **Molecule Integration Tests**: End-to-end testing with pre-built container images

## Architecture

┌─────────────────────────────────────────────────┐
│ Pre-built Test Base Image (GHCR) │
│ - UBI9 base │
│ - Go, Node.js, Python installed │
│ - Ansible + Molecule installed │
└─────────────────────────────────────────────────┘
│
↓
┌─────────────────────────────────────────────────┐
│ Podman launches container │
│ Mounts collection code │
└─────────────────────────────────────────────────┘
│
↓
┌─────────────────────────────────────────────────┐
│ Molecule runs inside container │
│ 1. Converge: Install MCP servers │
│ 2. Verify: Validate installation │
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
podman build -f .devcontainer/Containerfile -t ghcr.io/ansible/mcp-builder-test-base:latest .devcontainer/

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
# Full test suite (create, converge, verify, destroy)
cd extensions
molecule test -s integration

# Step-by-step for debugging
molecule create -s integration      # Create container
molecule converge -s integration    # Run installation
molecule verify -s integration      # Run validation tests
molecule destroy -s integration     # Clean up

# Keep container running for debugging
molecule test -s integration --destroy never

# Login to test container for manual debugging
molecule login -s integration
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
1. Image is pushed to GHCR
2. Workflow has correct permissions
3. GITHUB_TOKEN has packages:write scope
```

## CI/CD Pipeline

Tests run automatically on:

### Triggers

- **Pull Requests**: All tests run
- **Push to main/devel**: All tests + image build
- **Manual**: `workflow_dispatch` for on-demand testing

### Pipeline Stages

1. **Ansible Lint** (2-3 min)
   - Validates playbook/role syntax
   - Checks best practices

2. **Sanity Tests** (5-10 min per version)
   - Runs against Ansible 2.14, 2.15, 2.16
   - Validates collection structure

3. **Integration Tests** (10-15 min)
   - Pulls test base image
   - Runs full Molecule test suite
   - Validates MCP server installation

## Adding New Tests

### For a New MCP Server Role

1. Create role structure:

```bash
mkdir -p roles/new_mcp_server/{tasks,defaults,templates}
```

2. Add installation tasks in `roles/new_mcp_server/tasks/main.yml`

3. Add to integration test:

```yaml
# extensions/molecule/integration/converge.yml
- name: Install New MCP Server
  ansible.builtin.include_role:
    name: ansible.mcp_builder.new_mcp_server
```

4. Add verification in `verify.yml`:

```yaml
- name: Verify new_mcp_server is registered
  ansible.builtin.assert:
    that:
      - "'new_mcp_server' in manifest_data.servers"
```

### For New Test Scenarios

```bash
# Create new scenario
cd extensions/molecule
mkdir new_scenario
cd new_scenario

# Create molecule.yml, converge.yml, verify.yml
molecule init scenario new_scenario

# Run it
molecule test -s new_scenario
```

## Test Coverage Goals

- [ ] All roles have passing integration tests
- [ ] All MCP servers can be installed successfully
- [ ] Manifest generation is validated
- [ ] mcp_manage script functionality is tested
- [ ] Cross-platform testing (UBI8, UBI9, Ubuntu)
- [ ] Error handling scenarios are tested

## Resources

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Ansible Test Documentation](https://docs.ansible.com/ansible/latest/dev_guide/testing.html)
- [Ansible Lint Rules](https://ansible-lint.readthedocs.io/)
