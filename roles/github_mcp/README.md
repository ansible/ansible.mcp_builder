# GitHub MCP Role

Builds and installs [GitHub MCP server](https://github.com/github/github-mcp-server) from source. The server is automatically registered in the MCP server registry system.

## Dependencies

This role depends on the `common` role for Go environment setup and registry system.

## Variables

The following variables can be customized:

```yaml
# GitHub MCP Server repository details
github_mcp_repo: "https://github.com/github/github-mcp-server.git"
github_mcp_branch: "main"

```

## Registry Integration

This role automatically registers the GitHub MCP server in the global registry:

```yaml
github_mcp_registry:
  - name: "github-mcp-server"
    type: "go"
    args: ["stdio"]
    description: "GitHub MCP Server - Access GitHub repositories, issues, and pull requests"
```

The server is built to `/opt/mcp/bin/github-mcp-server` and can be executed via:
```bash
mcp_manage run github-mcp-server
```

## Example Usage

### Basic installation
```yaml
- name: Install GitHub MCP server
  hosts: localhost
  roles:
    - ansible.mcp_builder.github_mcp  # Depends on common role and builds GitHub server
```

### Custom repository and binary name
```yaml
- name: Install GitHub MCP from custom fork
  hosts: localhost
  vars:
    github_mcp_repo: "https://github.com/myorg/github-mcp-server.git"
    github_mcp_branch: "feature-branch"
    common_golang_version: "1.25.0"  # From common role
  roles:
    - ansible.mcp_builder.github_mcp
```

## Usage

After installation, the GitHub MCP server can be managed via the `mcp_manage` script:

```bash
# List all servers (including github-mcp-server)
mcp_manage list

# Get information about the GitHub server
mcp_manage info github-mcp-server

# Run the GitHub MCP server
mcp_manage run github-mcp-server

# Run with additional arguments
mcp_manage run github-mcp-server --debug --gh-host github.enterprise.com
```
