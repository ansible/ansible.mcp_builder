# Azure MCP Server Role

Builds and installs the [Azure MCP server](https://github.com/Azure/azure-mcp) from npm, enabling AI agents to interact with Azure resources through the Model Context Protocol and registered in the collection's unified MCP registry for usage by the [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) collection.

## Configuration

### Namespaces

The Azure MCP server supports multiple namespaces. By default, only the `az` namespace is enabled. You can configure additional namespaces:
```yaml
azure_mcp_namespaces:
  - "az"           # Azure CLI tools
  - "azd"          # Azure Developer CLI
  - "bestpractices" # Azure best practices
  - "aks"          # Azure Kubernetes Service
  - "compute"      # Azure Compute (VMs, scale sets)
  - "storage"      # Azure Storage operations
  - "network"      # Azure networking resources
```

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `azure_mcp_namespaces` | `["az"]` | Azure namespaces to enable. The first namespace in the list is used for the `--namespace` argument. Can be overridden by passing variables or var files. |

## Usage

To install the `azure_mcp` server using this role, add it to the `mcp_server` list when calling the primary `install_mcp` playbook in an EE definition file.

```
RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=azure_mcp
```

## License

GNU General Public License v3.0 or later. See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
