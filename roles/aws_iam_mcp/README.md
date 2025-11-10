# AWS IAM MCP Server Role

Builds and installs the [AWS IAM MCP server](https://awslabs.github.io/mcp/servers/iam-mcp-server/) from PyPI. The server is automatically registered in the MCP server registry system for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

Details taken from AWS IAM MCP server [configuration documentation](https://awslabs.github.io/mcp/servers/iam-mcp-server/#configuration).

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

## Variables

No customizable installation options at this time.

## Registry Integration

This role automatically registers the GitHub MCP server in the global registry:

```yaml
aws_iam_mcp_registry:
  - name: "awslabs.iam-mcp-server"
    lang: "pypi"
    type: stdio
    args: []
```

The server is installed via `uv` and can be executed via:
```bash
mcp_manage run awslabs.iam-mcp-server
```

## Example Usage

To be added.

```

## Usage

After installation, the AWS IAM MCP server can be managed via the `mcp_manage` script:

```bash
# List all servers (including awslabs.iam-mcp-server)
mcp_manage list

# Get information about the GitHub server
mcp_manage info awslabs.iam-mcp-server

# Run the GitHub MCP server
mcp_manage run awslabs.iam-mcp-server

# Run with additional arguments
mcp_manage run awslabs.iam-mcp-server --example-arg
