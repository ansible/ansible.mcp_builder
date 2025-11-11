# Azure MCP Server Role

Builds and installs the [Azure MCP server](https://github.com/Azure/azure-mcp) from npm, enabling AI agents to interact with Azure resources through the Model Context Protocol and registered in the collection's unified MCP registry for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

### Azure Authentication
The server requires Azure credentials to be configured. You can use any of the following methods:

1. Azure CLI (recommended):
```bash
    az login
```

2. Environment Variables (Service Principal):
```bash
    export AZURE_TENANT_ID=your-tenant-id
    export AZURE_CLIENT_ID=your-client-id
    export AZURE_CLIENT_SECRET=your-client-secret
```

3. Managed Identity: The server will automatically use Managed Identity when running on Azure services (VMs, App Service, Functions, etc.).

### Namespaces

The Azure MCP server supports multiple namespaces. By default, only the `az` namespace is enabled. You can configure additional namespaces:
```yaml
azure_mcp_namespaces:
  - "az"           # Azure CLI tools
  - "azd"          # Azure Developer CLI
  - "bestpractices" # Azure best practices
  - "aks"          # Azure Kubernetes Service
  - `compute`      # Azure Compute (VMs, scale sets)
  - `storage`      # Azure Storage operations
  - `network`      # Azure networking resources
```

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `azure_mcp_package` | `@azure/mcp` | npm package name for Azure MCP |
| `azure_mcp_version` | `latest` | Package version (e.g., `0.6.0` or `latest`) |
| `azure_mcp_namespaces` | `["az"]` | Azure namespaces to enable |

## Dependencies

- `ansible.mcp_builder.common` - Provides Node.js installation and base setup

## Registry Integration

This role automatically registers the Azure MCP server in the global registry:
```yaml
azure_mcp_registry:
  - name: "azmcp"
    type: "stdio"
    lang: "npm"
    package: "@azure/mcp"
    args:
      - "server"
      - "start"
      - "--namespace"
      - "az"
    description: "Azure MCP Server - Interact with Azure resources via Model Context Protocol"
```

The server is installed via npm and can be executed via:
```bash
mcp_manage run azmcp
```

## Usage

After installation, the Azure MCP server can be managed via the `mcp_manage` script:
```bash
# List all servers (including azmcp)
mcp_manage list

# Get information about the Azure server
mcp_manage info azmcp

# Run the Azure MCP server
mcp_manage run azmcp
```

## Requirements

- Node.js 20+ (automatically installed by the common role)
- npm
- `libicu` library (for .NET runtime, included in `bindep.txt`)

## Example Usage

### In execution-environment.yml
```yaml
additional_build_steps:
  append_final: |
    RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=azure_mcp
```

### Multiple servers
```yaml
additional_build_steps:
  append_final: |
    RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=github_mcp,aws_iam_mcp,azure_mcp
```

## Example Playbook
```yaml
---
- name: Install Azure MCP Server
  hosts: all
  roles:
    - role: ansible.mcp_builder.azure_mcp
      vars:
        azure_mcp_namespaces:
          - "az"
          - "aks"
```

## Generated Manifest Entry

After building an EE with this role, the Azure MCP server will be available in `/opt/mcp/mcpservers.json`:
```json
{
  "azmcp": {
    "type": "stdio",
    "command": "npx --prefix /opt/mcp/npm_installs azmcp",
    "args": [
      "server",
      "start",
      "--namespace",
      "az"
    ],
    "description": "Azure MCP Server - Interact with Azure resources via Model Context Protocol",
    "package": "@azure/mcp"
  }
}
```

## Testing

### Run Molecule Tests
```bash
cd roles/azure_mcp
molecule test
```

### Linting
```bash
ansible-lint .
```

## Troubleshooting

### Issue: npm install fails

**Solution**: Ensure Node.js is installed via the common role.

### Issue: Azure MCP command not found

**Solution**: Verify the installation path:
```bash
ls -la /opt/mcp/npm_installs/node_modules/@azure/mcp
```
