# GitHub MCP Role

Builds and installs GitHub MCP server from source.

## Dependencies

This role depends on the `common` role for Go environment setup.

## Variables

The following variables can be customized:

```yaml
# GitHub MCP Server repository details
github_mcp_repo: "https://github.com/github/github-mcp-server.git"
github_mcp_branch: "main"

# Whether to cleanup source code after build (default: true)
github_mcp_cleanup_source: true
```

## Example Usage

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
