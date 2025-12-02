# Common Role

Sets up a generic MCP build environment with automatic dependency detection and installs MCP servers from multiple sources (Go, npm, PyPI). Generates a unified manifest file and management script for all MCP servers.

## Features

- **Automatic dependency detection** - Installs Go, Node.js/npm, and uv based on discovered MCP servers
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
- **`pypi`** - Python packages installed with `uv tool install` (executables in `/opt/mcp/bin/`)
- **`go`** - Source builds compiled to `/opt/mcp/bin/`

## License

GNU General Public License v3.0 or later. See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.