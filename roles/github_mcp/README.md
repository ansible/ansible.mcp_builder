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

Set the `github_mcp_mode` variable to `'remote'`.

### Authentication

#### Local Mode
Set the `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable when running the server.

#### Remote Mode
See the [GitHub MCP Server documentation](https://github.com/github/github-mcp-server?tab=readme-ov-file#remote-github-mcp-server) for details.

### Toolsets

To configure allowed functionality for local mode, see the GitHub MCP server's [tool configuration](https://github.com/github/github-mcp-server?tab=readme-ov-file#tool-configuration) documentation.

To configure toolsets in remote mode, set the `github_mcp_registry.path` to the desired toolset URL (see GitHub's remote toolset documentation [here](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md#remote-mcp-toolsets)).

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `github_mcp_build_repo` | `["https://github.com/github/github-mcp-server.git"]` | Repository for the Github MCP server source. |
| `github_mcp_build_repo_branch` | `["main"]` | Branch to pull source from. |
| `github_mcp_mode` | `["local"]` | Install the Github MCP server locally or use the remotely hosted Github MCP server. |
| `github_mcp_registry.path` | `["https://api.githubcopilot.com/mcp/"]` | Endpoint for specified MCP server tools. Can be modified to more specific toolsets. |

## Usage

To install the `github_mcp` server using this role, add it to the `mcp_server` list when calling the primary `install_mcp` playbook in an EE definition file.

```
RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=github_mcp
```

## License

GNU General Public License v3.0 or later. See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.