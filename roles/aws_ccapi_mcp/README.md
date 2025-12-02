# AWS Cloud Control MCP Server Role

Installs the [AWS Cloud Control MCP server](https://awslabs.github.io/mcp/servers/ccapi-mcp-server) from PyPI. The server is automatically registered in the MCP server registry system for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

Details taken from AWS Cloud Control MCP server [environment variables documentation](https://awslabs.github.io/mcp/servers/ccapi-mcp-server#environment-variables-1).

### AWS Credentials
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

3. IAM Roles (for EC2/Lambda): The server will automatically use IAM roles when running on AWS services.

4. AWS SSO: Configure SSO profile and set AWS_PROFILE (region from profile used automatically)

### Environment Variables

The server's default behavior can be customized through environment variables, similar to the credentials above.

See the documentation [here](https://awslabs.github.io/mcp/servers/ccapi-mcp-server#server-configuration) for configuration details on tagging resources and security scanning options.

## Usage

To install the `aws_ccapi_mcp` server using this role, add it to the `mcp_server` list when calling the primary `install_mcp` playbook in an EE definition file.

```
RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=aws_ccapi_mcp
```

## License

GNU General Public License v3.0 or later. See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
