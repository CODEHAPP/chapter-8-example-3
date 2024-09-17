#!/bin/bash

#
# Deploys the Node.js microservice to Kubernetes.
#
# Assumes the image has already been built and published to the container registry.
#
# Environment variables:
#
#   CONTAINER_REGISTRY - The hostname of your container registry.
#   VERSION - The version number of the image to deploy.
#
# Usage:
#
#   ./scripts/deploy.sh
#

set -u # or set -o nounset
: "$CONTAINER_REGISTRY"
: "$VERSION"

# Output the variables for confirmation
echo "Deploying version $VERSION to registry $CONTAINER_REGISTRY"

# Generate and check the deploy.yaml file with environment variables substituted
envsubst < ./scripts/kubernetes/deploy.yaml > ./scripts/kubernetes/deploy.generated.yaml
cat ./scripts/kubernetes/deploy.generated.yaml

# Apply the deployment
kubectl apply -f ./scripts/kubernetes/deploy.generated.yaml

# Check Kubernetes deployment status
kubectl get pods
kubectl get svc
