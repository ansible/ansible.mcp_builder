# GitHub MCP Server Role

Builds and installs [GitHub MCP server](https://github.com/github/github-mcp-server) from source. The server is automatically registered in the MCP server registry system.

## Configuration

The `GITHUB_PERSONAL_ACCESS_TOKEN` is a required variable for the MCP server to operate.

See the documentation [here](https://github.com/github/github-mcp-server?tab=readme-ov-file#environment-variables-recommended) for details on how Github recommends setting environment variables.

### Toolsets

To configure allowed functionality, see the Github MCP server's [tool configuration](https://github.com/github/github-mcp-server?tab=readme-ov-file#tool-configuration) documentation.

## Registry Integration

This role automatically registers the GitHub MCP server in the global registry:

```yaml
github_mcp_registry:
  - name: "github-mcp-server"
    lang: "go"
    type: "stdio"
    args: ["stdio"]
    description: "GitHub MCP Server - Access GitHub repositories, issues, and pull requests"
```

## Example Usage

To be added.

## Usage

After installation, the GitHub MCP server can be managed manually via the `mcp_manage` script:

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
