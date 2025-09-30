# Common Role

Sets up a generic MCP build environment with automatic dependency detection and installs MCP servers from multiple sources (Go, npm, PyPI). Generates a unified manifest file and management script for all MCP servers.

## Features

- **Automatic dependency detection** - Installs Go, Node.js/npm, and uv/uvx based on discovered MCP servers
- **MCP server registry system** - Unified registry where any role can contribute server definitions
- **Manifest generation** - Creates `/opt/mcp/mcpservers.json` with all server details
- **Management script** - Provides `mcp_manage` command-line tool for server execution
- **Multiple server types** - Supports npm, PyPI, and source build installations

## Variables

The following variables can be customized:

```yaml
# Go version to install (default: "1.24.4")
common_golang_version: "1.25.0"

# Base path for MCP installations (default: "/opt/mcp")
common_mcp_base_path: "/opt/mcp"

# Binary management path (default: "/usr/local/bin")
common_mcp_bin_path: "/usr/local/bin"

# Go environment paths
common_go_path: "/go"           # GOPATH (default: "/go")
common_go_cache: "/tmp/go-cache" # GOCACHE (default: "/tmp/go-cache")

# MCP Server Registry - define your MCP servers here
common_mcp_registry:
  - name: "mcp-hello-world"
    type: "npm"
    args: []
  - name: "awslabs.iam-mcp-server"
    type: "pypi"
    args: []
```

## Registry System

The common role uses a registry system to discover MCP servers from all roles. Each role can contribute servers by defining a `{role_name}_mcp_registry` variable.

### Server Definition Format

```yaml
<role_name - e.g. github>_mcp_registry:
  - name: "server-executable-name"
    type: "npm|pypi|go"
    args: ["list", "of", "default", "arguments"]
    description: "Optional server description"
```

### Server Types

- **`npm`** - Packages installed via npm and executed with `npx`
- **`pypi`** - Python packages installed with `uv tool install` and executed with `uvx`
- **`go`** - Source builds compiled to `/opt/mcp/bin/`

## Generated Files

- **`/opt/mcp/mcpservers.json`** - JSON manifest of all MCP servers
- **`/opt/mcp/mcp_manage`** - Server management script
- **`/usr/local/bin/mcp_manage`** - Symlink for global access

## Example Usage

### Basic installation with custom servers
```yaml
- name: Setup MCP environment with custom servers
  hosts: localhost
  vars:
    common_mcp_base_path: "/opt/mcp"
    common_mcp_registry:
      - name: "my-custom-server"
        type: "npm"
        args: ["--verbose"]
        description: "My custom MCP server"
  roles:
    - ansible.mcp_builder.common
```

### Using with other MCP roles
```yaml
- name: Install MCP servers from multiple roles
  hosts: localhost
  roles:
    - ansible.mcp_builder.common      # Installs npm/pypi servers
    - ansible.mcp_builder.github_mcp  # Adds github-mcp-server
    # Any other MCP server roles...
```

## Using the Management Script

After installation, use the `mcp_manage` script to interact with servers:

```bash
# List all available servers
mcp_manage list

# Get server information
mcp_manage info github-mcp-server

# Run a server
mcp_manage run github-mcp-server

# Run with additional arguments
mcp_manage run github-mcp-server --debug
```
