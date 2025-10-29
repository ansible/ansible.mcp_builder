# Common Role

Sets up a generic MCP build environment with automatic dependency detection and installs MCP servers from multiple sources (Go, npm, PyPI). Generates a unified manifest file and management script for all MCP servers.

## Features

- **Automatic dependency detection** - Installs Go, Node.js/npm, and uv/uvx based on discovered MCP servers
- **MCP server registry system** - Unified registry where any role can contribute server definitions
- **Manifest generation** - Creates `/opt/mcp/mcpservers.json` with all server details
- **Management script** - Provides `mcp_manage` command-line tool for server execution
- **Multiple server types** - Supports npm, PyPI, and source build installations

## Registry System

The common role uses a registry system to discover MCP servers from all roles. Each role can contribute servers by defining a `{role_name}_mcp_registry` variable.

### Server Definition Format

```yaml
<role_name - e.g. github>_mcp_registry:
  - name: "server-executable-name"
    type: "http|stdio"
    lang: "npm|pypi|go"
    args: ["list", "of", "default", "arguments"]
    description: "Optional server description"
```

### Server "Languages" Supported

- **`npm`** - Packages installed via npm and executed with `npx`
- **`pypi`** - Python packages installed with `uv tool install` and executed with `uvx`
- **`go`** - Source builds compiled to `/opt/mcp/bin/`

## Generated Files

- **`/opt/mcp/mcpservers.json`** - JSON manifest of all MCP servers
- **`/opt/mcp/mcp_manage`** - Server management script

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
