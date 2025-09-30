# Ansible MCP Builder Collection

This repository contains the `ansible.mcp_builder` Ansible Collection.

An Ansible collection for building and installing MCP (Model Context Protocol) servers from various sources including npm, PyPI, and source builds.

## About

The Ansible MCP Builder collection provides roles to build and install MCP servers into environments. It features a unified registry system where different roles can contribute their MCP servers, and automatically generates a manifest file and management script for easy server execution. The collection is designed for use with Ansible Execution Environments (EEs).

## Included Content

### **Roles**

Name | Description
--- | ---
[ansible.mcp_builder.common](roles/common/README.md) | Installs dependencies and sets up generic environment for MCP servers.
[ansible.mcp_builder.github_mcp](roles/github_mcp/README.md) | Install the [Github MCP Server](https://github.com/github/github-mcp-server).

## MCP Server Management

After installation, the collection provides:

- **MCP Server Manifest** (`/opt/mcp/mcpservers.json`) - JSON file describing all installed MCP servers
- **Management Script** (`mcp_manage`) - Command-line tool for running MCP servers

### Using the MCP Management Script

List all available MCP servers:
```bash
mcp_manage list
```

Get information about a specific server:
```bash
mcp_manage info github-mcp-server
```

Run an MCP server:
```bash
mcp_manage run github-mcp-server
mcp_manage run mcp-hello-world
mcp_manage run iam-mcp-server
```

Run with additional arguments:
```bash
mcp_manage run github-mcp-server --debug --token $GITHUB_TOKEN
```

## MCP Server Registry System

The collection uses a unified registry system where roles can contribute MCP server definitions. Each role defines a `{role_name}_mcp_registry` variable containing server definitions.

### Server Types

| Type | Description | Path Convention |
|------|-------------|----------------|
| `npm` | npm packages | `npx --prefix /opt/mcp/npm_installs {name}` |
| `pypi` | Python packages via uvx | `uvx {name}` |
| `go` | Source builds (any compiled binary) | `/opt/mcp/bin/{name}` |

### Example Registry Definition

```yaml
# In roles/{role_name}/defaults/main.yml
my_role_mcp_registry:
  - name: "my-awesome-server"
    type: "go"
    args: ["stdio"]
    description: "My custom MCP server"
  - name: "my-npm-server"  
    type: "npm"
    args: ["--config", "production"]
```

## MCP Server Manifest Format

The generated `/opt/mcp/mcpservers.json` file contains all server definitions:

```json
{
    "mcp-hello-world": {
        "type": "npm",
        "path": "npx --prefix /opt/mcp/npm_installs mcp-hello-world",
        "args": []
    },
    "aws-iam-mcp-server": {
        "type": "pypi",
        "path": "uvx awslabs.iam-mcp-server",
        "args": [],
        "package": "awslabs.iam-mcp-server"
    },
    "github-mcp-server": {
        "type": "go",
        "path": "/opt/mcp/bin/github-mcp-server",
        "args": ["stdio"],
        "description": "GitHub MCP Server - Access GitHub repositories, issues, and pull requests"
    }
}
```

## Install MCP in EE via the ansible.mcp_builder roles

The `ansible.mcp_builder` role is designed to run as a final step in building an EE.

```
  append_final: |
    RUN ansible-playbook ansible.mcp_builder.install_mcp
```

### Prerequisities

- `ansible.mcp_builder` cloned localy
- `ansible.mcp` cloned locally

Use the provided [examples/](examples/). You will need the `test-playbook.yml`, `requirements.yml`, and `execution-environment.yml` files.

Update the [examples/execution-environment.yml](examples/execution-environment.yml)`additional_build_files` paths with your local paths to the cloned collections.

### Building an EE

To build the execution environment, run:

```
ansible-builder build --tag my-mcp-ee:latest
```

### Running the test playbook

After the EE is built successfully, run a test with the test-playbook.

Update the `Create GitHub issue` task to fill out your desired repo and issue details.

Run with:

```
ansible-navigator run test-playbook.yml --eei localhost/my-mcp-ee:latest --ce podman --pp never -m stdout
```

The Github issue will be created with your specified details.

See
[Ansible Using Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)
for more details.

## Release notes

See the
[changelog](https://github.com/ansible-collections/ansible.mcp_builder/tree/main/CHANGELOG.rst).


## More information

<!-- List out where the user can find additional information, such as working group meeting times, slack/matrix channels, or documentation for the product this collection automates. At a minimum, link to: -->

- [Ansible collection development forum](https://forum.ansible.com/c/project/collection-development/27)
- [Ansible User guide](https://docs.ansible.com/ansible/devel/user_guide/index.html)
- [Ansible Developer guide](https://docs.ansible.com/ansible/devel/dev_guide/index.html)
- [Ansible Collections Checklist](https://docs.ansible.com/ansible/devel/community/collection_contributors/collection_requirements.html)
- [Ansible Community code of conduct](https://docs.ansible.com/ansible/devel/community/code_of_conduct.html)
- [The Bullhorn (the Ansible Contributor newsletter)](https://docs.ansible.com/ansible/devel/community/communication.html#the-bullhorn)
- [News for Maintainers](https://forum.ansible.com/tag/news-for-maintainers)

## Licensing

GNU General Public License v3.0 or later.

See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
