# GitHub MCP Server Role

Installs and configures the [GitHub MCP server](https://github.com/github/github-mcp-server). Supports both local (build from source) and remote (GitHub-hosted) modes. The server is automatically registered in the MCP server registry system.

## Modes

This role supports two deployment modes:

### Local Mode (default)
- Builds the server from source using Go
- Runs locally via `stdio` protocol

### Remote Mode
- Uses GitHub's hosted MCP service at `https://api.githubcopilot.com/mcp/`


## Configuration

### Switching to remote mode

Set the `github_mcp_mode` variable in your playbook or extra vars:

```bash
ansible-playbook install_mcp.yml -e mcp_servers=github_mcp -e github_mcp_mode=remote
```

### Authentication

#### Local Mode
Set the `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable when running the server.

#### Remote Mode
See the [GitHub MCP Server documentation](https://github.com/github/github-mcp-server?tab=readme-ov-file#remote-github-mcp-server) for details.

### Toolsets

To configure allowed functionality for local mode, see the GitHub MCP server's [tool configuration](https://github.com/github/github-mcp-server?tab=readme-ov-file#tool-configuration) documentation.

To configure toolsets in remote mode, set the `github_mcp_remote_config.path` to the desired toolset URL (see GitHub's remote toolset documentation [here](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md#remote-mcp-toolsets)).

## Registry Integration

This role automatically registers the GitHub MCP server based on the selected mode:

### Local

```yaml
github_mcp_registry:
  - name: "github-mcp-server"
    type: "stdio"
    lang: "go"
    args: ["stdio"]
    description: "GitHub MCP Server (local build)"
```

### Remote

```yaml
github_mcp_registry:
  - name: "github-mcp-server"
    type: "http"
    path: "https://api.githubcopilot.com/mcp/"
    args: []
    description: "GitHub MCP Server (remote)"
```

## Usage

After installation, manage the server via `mcp_manage`.

### Local Mode

```bash
# List all servers
mcp_manage list

# Get information about the MCP server
mcp_manage info github-mcp-server

# Run the MCP server
mcp_manage run github-mcp-server

# Run with additional arguments
mcp_manage run github-mcp-server --debug --gh-host github.enterprise.com
```

### Remote Mode

```bash
# View connection details
mcp_manage info github-mcp-server

# Note: Remote servers are accessed through MCP clients, not run locally
```
