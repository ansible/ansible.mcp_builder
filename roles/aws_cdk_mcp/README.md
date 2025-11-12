# AWS CDK MCP Server Role

Installs the [AWS CDK MCP server](https://awslabs.github.io/mcp/servers/cdk-mcp-server) from PyPI. The server is automatically registered in the MCP server registry system for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

Details taken from AWS CDK MCP server [installation documentation](https://awslabs.github.io/mcp/servers/cdk-mcp-server#installation).

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

## Registry Integration

This role automatically registers the GitHub MCP server in the global registry:

```yaml
aws_cdk_mcp_registry:
  - name: "awslabs.cdk-mcp-server"
    lang: "pypi"
    type: stdio
    args: []
```

The server is installed via `uv` and can be executed via:
```bash
mcp_manage run awslabs.cdk-mcp-server
```

## Example Usage

To be added.

```

## Usage

After installation, the AWS CDK MCP server can be managed via the `mcp_manage` script:

```bash
# List all servers
mcp_manage list

# Get information about the MCP server
mcp_manage info awslabs.cdk-mcp-server

# Run the MCP server
mcp_manage run awslabs.cdk-mcp-server

# Run with additional arguments
mcp_manage run awslabs.cdk-mcp-server --example-arg
