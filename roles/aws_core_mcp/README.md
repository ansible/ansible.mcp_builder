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

## Usage

To install the `aws_core_mcp` server using this role, add it to the `mcp_server` list when calling the primary `install_mcp` playbook in an EE definition file.

```
RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=aws_core_mcp
```

## License

GNU General Public License v3.0 or later. See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
