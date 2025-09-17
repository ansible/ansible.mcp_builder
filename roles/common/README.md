# Common Role

Sets up a generic MCP build environment with Go installation.

## Variables

The following variables can be customized:

```yaml
# Go version to install (default: "1.24.4")
common_golang_version: "1.25.0"

# Base path for MCP installations (default: "/opt/mcp")
common_mcp_base_path: "/opt/mcp"

# Go installation control
common_install_go: true         # Whether to install Go (default: true)

# Go environment paths
common_go_path: "/go"           # GOPATH (default: "/go")
common_go_cache: "/tmp/go-cache" # GOCACHE (default: "/tmp/go-cache")
```

## Example Usage

### Install with Go
```yaml
- name: Setup MCP environment with custom Go version
  hosts: localhost
  vars:
    common_golang_version: "1.25.0"
    common_mcp_base_path: "/opt/mcp"
    common_install_go: true
  roles:
    - ansible.mcp_builder.common
```

### Skip Go installation (use existing Go)
```yaml
- name: Setup MCP environment without installing Go
  hosts: localhost
  vars:
    common_mcp_base_path: "/opt/mcp"
    common_install_go: false  # Skip Go installation
  roles:
    - ansible.mcp_builder.common
```
