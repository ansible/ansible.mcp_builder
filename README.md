# POC - Building MCPs in Execution Environments 

A proof-of-concept for building MCPs into EEs via roles. 

Includes a role-based collection `ansible.mcp_builder` for building and installing MCP (Model Context Protocol) servers from source.

## Collection Contents

- **`common` role**: Sets up generic MCP build environment with Go
- **`github_mcp` role**: Builds GitHub MCP server from source

## Quick Start

```bash
# Install the collection
ade install -e collections/ansible_collections/ansible/mcp_builder

# Run with defaults
ansible-playbook ansible.mcp_builder.install_mcp --ask-become-pass
```

## Customization

### Go Version
```yaml
vars:
  common_golang_version: "1.25.0"  # Default: "1.24.4"
```

### Installation Path
```yaml
vars:
  common_mcp_base_path: "/opt/mcp"
```

### Custom Repository
```yaml
vars:
  github_mcp_repo: "https://github.com/myorg/github-mcp-server.git"
  github_mcp_branch: "feature-branch"
```

## Directory Structure

After installation, you'll find:
```
/opt/mcp/github/                   # Default location
├── github-mcp-server              # Compiled binary
└── github-mcp-server-wrapper      # Wrapper script
```

## Requirements

- Ansible >= 2.18
- Target system with curl, git, tar packages
- Sufficient disk space for Go installation (~500MB)

## Development

See individual role README files for detailed documentation:
- [Common Role](roles/common/README.md)
- [GitHub MCP Role](roles/github_mcp/README.md)
