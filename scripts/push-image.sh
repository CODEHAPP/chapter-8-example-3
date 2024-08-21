#!/bin/bash

set -e # Exit on any error
set -u # Treat unset variables as errors

# Debugging output
echo "CONTAINER_REGISTRY: $CONTAINER_REGISTRY"
echo "VERSION: $VERSION"
echo "REGISTRY_UN: $REGISTRY_UN"
echo "REGISTRY_PW: $REGISTRY_PW"

# Ensure environment variables are set
: "${CONTAINER_REGISTRY:?CONTAINER_REGISTRY is not set}"
: "${VERSION:?VERSION is not set}"
: "${REGISTRY_UN:?REGISTRY_UN is not set}"
: "${REGISTRY_PW:?REGISTRY_PW is not set}"

# Print debug information
echo "Debug Info:"
echo "CONTAINER_REGISTRY: $CONTAINER_REGISTRY"
echo "VERSION: $VERSION"
echo "REGISTRY_UN: $REGISTRY_UN"

# Perform docker login and check for errors
echo "$REGISTRY_PW" | docker login "$CONTAINER_REGISTRY" --username "$REGISTRY_UN" --password-stdin
if [ $? -ne 0 ]; then
    echo "Docker login failed. Please check your credentials."
    exit 1
fi

# Push the Docker image and handle errors
docker push "$CONTAINER_REGISTRY/video-streaming:$VERSION"
if [ $? -ne 0 ]; then
    echo "Docker push failed. Please check the image tag and connection to the registry."
    exit 1
fi

echo "Docker image pushed successfully!"
