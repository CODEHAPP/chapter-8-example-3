name: Deploy microservice

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      # Build Docker image
      - name: Build Docker image
        run: ./scripts/build-image.sh
        env:
          CONTAINER_REGISTRY: ${{ secrets.CONTAINER_REGISTRY }}
          VERSION: ${{ github.sha }}

      # Publish Docker image to container registry
      - name: Publish Docker image
        run: ./scripts/push-image.sh
        env:
          CONTAINER_REGISTRY: ${{ secrets.CONTAINER_REGISTRY }}
          VERSION: ${{ github.sha }}
          REGISTRY_UN: ${{ secrets.REGISTRY_UN }}
          REGISTRY_PW: ${{ secrets.REGISTRY_PW }}

      # Setup kubectl and deploy to Kubernetes
      - name: Setup kubectl
        uses: tale/kubectl-action@v1
        with:
          base64-kube-config: ${{ secrets.KUBE_CONFIG }}
          kubectl-version: v1.24.2

      - name: Deploy to Kubernetes
        run: ./scripts/deploy.sh
        env:
          CONTAINER_REGISTRY: ${{ secrets.CONTAINER_REGISTRY }}
          VERSION: ${{ github.sha }}
