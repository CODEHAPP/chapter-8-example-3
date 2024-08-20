#!/bin/bash

#
# Publishes a Docker image.
#
# Environment variables:
#
#   CONTAINER_REGISTRY - The hostname of your container registry.
#   REGISTRY_UN - User name for your container registry.
#   REGISTRY_PW - Password for your container registry.
#   VERSION - The version number to tag the images with.
#
# Usage:
#
#       ./scripts/push-image.sh
#

set -e # Exit on any error
set -u # Treat unset variables as errors

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
