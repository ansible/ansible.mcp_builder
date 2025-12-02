# Ansible MCP Builder Collection

The Ansible MCP Builder collection provides automated deployment and management of Model Context Protocol (MCP) servers within Ansible Execution Environments.

## Description

The `ansible.mcp_builder` collection provides roles to build and install MCP (Model Context Protocol) servers from various sources including npm, PyPI, and source builds. It features a unified registry system for server details, and automatically generates a manifest file for easy server execution via the [ansible.mcp collection](https://github.com/ansible-collections/ansible.mcp).

This collection is designed for Ansible automation users who want to integrate MCP servers into their automation workflows using Ansible Execution Environments (EEs). The collection simplifies the deployment process by handling dependencies, installation paths, and server configuration, allowing you to focus on using MCP servers rather than managing their setup.

## Included content

<!--start collection content-->
### Roles
Name | Description
--- | ---
[ansible.mcp_builder.common](roles/common/README.md)|Sets up a generic MCP build environment with automatic dependency detection and installs MCP servers from multiple sources (Go, npm, PyPI)
[ansible.mcp_builder.aws_ccapi_mcp](roles/aws_ccapi_mcp/README.md)|Installs the [AWS Cloud Control MCP server](https://awslabs.github.io/mcp/servers/ccapi-mcp-server) from PyPI
[ansible.mcp_builder.aws_cdk_mcp](roles/aws_cdk_mcp/README.md)|Installs the [AWS CDK MCP server](https://awslabs.github.io/mcp/servers/cdk-mcp-server) from PyPI
[ansible.mcp_builder.aws_core_mcp](roles/aws_core_mcp/README.md)|Installs the [AWS Core MCP server](https://awslabs.github.io/mcp/servers/core-mcp-server) from PyPI with dynamic proxy server strategy
[ansible.mcp_builder.aws_iam_mcp](roles/aws_iam_mcp/README.md)|Installs the [AWS IAM MCP server](https://awslabs.github.io/mcp/servers/iam-mcp-server/) from PyPI
[ansible.mcp_builder.azure_mcp](roles/azure_mcp/README.md)|Installs the [Azure MCP server](https://github.com/Azure/azure-mcp) from npm to interact with Azure resources
[ansible.mcp_builder.github_mcp](roles/github_mcp/README.md)|Installs the [GitHub MCP server](https://github.com/github/github-mcp-server) with support for local (build from source) and remote modes

<!--end collection content-->

## Requirements

- **ansible-core**: 2.18.0+
- **Python**: 3.11+
- **External dependencies**:
  - `ansible-builder` for building Execution Environments
  - `podman` or `docker` for container runtime
- **Collection dependencies**:
  - `ansible.mcp` for execution of MCP servers.

## Installation

Before using this collection, you need to install it with the Ansible Galaxy command-line tool:

```
ansible-galaxy collection install ansible.mcp_builder
```

You can also include it in a requirements.yml file and install it with `ansible-galaxy collection install -r requirements.yml`, using the format:

```yaml
collections:
  - name: ansible.mcp_builder
```

To upgrade the collection to the latest available version, run the following command:

```bash
ansible-galaxy collection install ansible.mcp_builder --upgrade
```

You can also install a specific version of the collection. Use the following syntax to install version 1.0.0:

```
ansible-galaxy collection install ansible.mcp_builder:==1.0.0
```

See [using Ansible collections](https://docs.ansible.com/ansible/devel/user_guide/collections_using.html) for more details.

## Use Cases

### 1. Building an Execution Environment with MCP Servers

The `ansible.mcp_builder` collection is designed to run as a step in building an Execution Environment (EE), allowing you to deploy multiple MCP servers from various sources (npm packages, PyPI packages, and compiled Go binaries) in a single environment.

To select which MCP servers to install, use the `-e` flag with the `mcp_servers` variable. Servers are selected by their exact role name (e.g., `github_mcp`).

**Example `execution-environment.yml` configuration**:

```yaml
  append_final: |
    RUN ansible-playbook ansible.mcp_builder.install_mcp -e mcp_servers=github_mcp,azure_core_mcp <-e additional-vars-or-vars-file>
```

**Build the execution environment**:

```bash
ansible-builder build --tag my-mcp-ee:latest
```

This approach allows you to create custom execution environments with only the MCP servers you need, keeping your container images lean and purpose-built for your specific automation workflows.

### 2. GitHub MCP Server for Repository Automation

Deploy an Execution Environment with the GitHub MCP server to automate GitHub operations through Ansible playbooks. This enables you to create issues, manage pull requests, and interact with repositories programmatically.

**Example workflow**: Build an EE with the GitHub MCP server for automated issue tracking and repository management in CI/CD pipelines. After building the EE, use it to run playbooks that create issues, label pull requests, or manage repository settings. 

To run the playbook locally with the EE, use:

```bash
ansible-navigator run github-playbook.yml --eei localhost/my-mcp-ee:latest --ce podman --pp never -m stdout
```


**Authentication**: The GitHub MCP server requires a GitHub token for authentication, which can be passed as an environment variable or parameter when invoking the MCP server.
sible.mcp` collection modules.

### 3. Multi-Cloud Automation with MCP Servers

Combine multiple MCP servers for comprehensive cloud and version control automation. For example, deploy an EE with GitHub MCP (Go binary or remotely hosted), Azure MCP (npm package), and AWS Core MCP (PyPI package) to manage resources across different platforms from a single Ansible workflow.

**Example use case**: Create a deployment pipeline that:
- Perform operations using the AWS Core MCP server's available proxy servers
- Configures Azure resources using the Azure MCP server
- Updates GitHub repository settings and creates deployment issues using the GitHub MCP server

All of these operations can be orchestrated from a single Ansible playbook running in your custom execution environment.


## Testing

This collection has been tested in the following environments:

- **Execution Environments**: Built with `ansible-builder` 3.x
- **Container Runtimes**: Podman 4.x, Docker 24.x
- **Operating Systems**: RHEL 9, Fedora 38+, Ubuntu 22.04+
- **Ansible Core versions**: 2.16+ - 2.20+
- **Python versions**: 3.10-3.13

### Testing Process

The collection includes example configurations in the `examples/` directory for building and testing Execution Environments with various server and base image combinations.



## Contributing

We welcome contributions to this collection! If you find problems, please open an issue or create a PR against the [ansible.mcp_builder collection repository](https://github.com/ansible-collections/ansible.mcp_builder).

For complete details on contributing to Ansible collections, see [Contributing to Ansible-maintained collections](https://docs.ansible.com/ansible/devel/community/contributing_maintained_collections.html#contributing-maintained-collections).

### Community Channels

- [Ansible collection development forum](https://forum.ansible.com/c/project/collection-development/27)
- [Ansible Community code of conduct](https://docs.ansible.com/ansible/devel/community/code_of_conduct.html)

Please read and familiarize yourself with the Ansible project's [Code of Conduct](https://docs.ansible.com/ansible/devel/community/code_of_conduct.html).

## Support

For support and questions:
- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/ansible-collections/ansible.mcp_builder/issues)
- **Community Help**: Available on the [Ansible Forum](https://forum.ansible.com/)
- **Discussions**: Join the [Ansible collection development forum](https://forum.ansible.com/c/project/collection-development/27)

## Release Notes and Roadmap

Release notes are available in the [CHANGELOG.rst](https://github.com/ansible-collections/ansible.mcp_builder/tree/main/CHANGELOG.rst).

## Related Information

- [Ansible Using Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)
- [Ansible User guide](https://docs.ansible.com/ansible/devel/user_guide/index.html)
- [Ansible Developer guide](https://docs.ansible.com/ansible/devel/dev_guide/index.html)
- [Ansible Collections Checklist](https://docs.ansible.com/ansible/devel/community/collection_contributors/collection_requirements.html)
- [The Bullhorn (the Ansible Contributor newsletter)](https://docs.ansible.com/ansible/devel/community/communication.html#the-bullhorn)
- [News for Maintainers](https://forum.ansible.com/tag/news-for-maintainers)
- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)

## License Information

GNU General Public License v3.0 or later.

See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
