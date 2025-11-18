#!/bin/bash
# This script is used to build the container image for the ansible.mcp_builder repository.
set -euo pipefail

IMAGE_TAG="ghcr.io/ansible/mcp-builder-test-base:latest"
PUSH_IMAGE=false
RUN_TESTS=false

# Get repo root (script is in tools/, so go up one level)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --push)
      PUSH_IMAGE=true
      shift
      ;;
    --test)
      RUN_TESTS=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--push] [--test]"
      echo "  --push  Push image to GHCR after building"
      echo "  --test  Run Molecule integration tests"
      exit 1
      ;;
  esac
done

echo "Building container image..."
podman build -f "$REPO_ROOT/Containerfile" -t $IMAGE_TAG "$REPO_ROOT"

echo "Testing the built image..."
podman run --rm $IMAGE_TAG ansible --version

if [ "$PUSH_IMAGE" = true ]; then
  echo "Pushing container image to GHCR..."
  podman push $IMAGE_TAG
fi

if [ "$RUN_TESTS" = true ]; then
  echo ""
  echo "Running Molecule Integration Tests"
  echo "======================================"
  # Find podman socket (works for both Linux and macOS)
  PODMAN_SOCKET=$(podman info --format '{{.Host.RemoteSocket.Path}}' 2>/dev/null || echo "")
  if [ -z "$PODMAN_SOCKET" ] || [ ! -S "$PODMAN_SOCKET" ]; then
    # Try common locations
    for sock in /run/podman/podman.sock ~/.local/share/containers/podman/machine/podman-machine-default/podman.sock; do
      if [ -S "$sock" ]; then
        PODMAN_SOCKET="$sock"
        break
      fi
    done
  fi

  # Mount podman socket and binary for container-in-container
  if [ -n "$PODMAN_SOCKET" ] && [ -S "$PODMAN_SOCKET" ]; then
    echo "Using podman socket: $PODMAN_SOCKET"
    podman run --rm \
      -v "$REPO_ROOT:/workspace:Z" \
      -v "$PODMAN_SOCKET:/run/podman/podman.sock:Z" \
      --privileged \
      -w /workspace/extensions \
      -e MOLECULE_PROJECT_DIRECTORY=/workspace/extensions \
      $IMAGE_TAG \
      molecule test -s integration --destroy=always
  else
    echo "Podman socket not found. Running without socket mount (may not work)."
    podman run --rm \
      -v "$REPO_ROOT:/workspace:Z" \
      --privileged \
      -w /workspace/extensions \
      -e MOLECULE_PROJECT_DIRECTORY=/workspace/extensions \
      $IMAGE_TAG \
      molecule test -s integration --destroy=always
  fi
  echo ""
  echo "Tests completed!"
fi

echo "Done! Image: $IMAGE_TAG"
