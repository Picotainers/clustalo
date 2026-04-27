# clustalo
Source-built `clustalo` container.

## Quick Usage
```bash
# Pull the image
docker pull docker.io/picotainers/clustalo:latest

# Run the tool
docker run --rm docker.io/picotainers/clustalo:latest --help
```

## Example
```bash
docker run --rm -v "$(pwd):/data" docker.io/picotainers/clustalo:latest --help
```
