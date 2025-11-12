# AWS Core MCP Server Role

Installs the [AWS Core MCP server](https://awslabs.github.io/mcp/servers/core-mcp-server) from PyPI. The server is automatically registered in the MCP server registry system for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

The server operates with a dynamic proxy server strategy to import and proxy other MCP servers based on role-based environment variables.

View the AWS Core MCP server [role-based server configuration](https://awslabs.github.io/mcp/servers/core-mcp-server#role-based-server-configuration) documentation to see available servers.

Servers can be utilized by setting environment variables as indicated in the above documentation.

The server requires AWS credentials to be configured. You can use any of the following methods:

1. AWS Profile (recommended):

    ```bash
    export AWS_PROFILE=your-profile-name
    ```

2. Environment Variables:
    ```bash
    export AWS_ACCESS_KEY_ID=your-access-key
    export AWS_SECRET_ACCESS_KEY=your-secret-key
    export AWS_REGION=us-east-1
    ```

## Registry Integration

This role automatically registers the GitHub MCP server in the global registry:

```yaml
aws_core_mcp_registry:
  - name: "awslabs.core-mcp-server"
    lang: "pypi"
    type: stdio
    args: []
```

The server is installed via `uv` and can be executed via:
```bash
mcp_manage run awslabs.core-mcp-server
```

## Example Usage

To be added.

## Usage

After installation, the AWS Core MCP server can be managed via the `mcp_manage` script:

```bash
# List all servers
mcp_manage list

# Get information about the MCP server
mcp_manage info awslabs.core-mcp-server

# Run the MCP server
mcp_manage run awslabs.core-mcp-server

# Run with additional arguments
mcp_manage run awslabs.core-mcp-server --example-arg
```
