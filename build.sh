#!/usr/bin/env bash
# Usage: DOCKERHUB_USER=me ./build.sh <dev|prod> [tag]
set -euo pipefail
ENV="${1:?Usage: ./build.sh <dev|prod> [tag]}"
TAG="${2:-latest}"
IMAGE="${DOCKERHUB_USER:?set DOCKERHUB_USER}/${ENV}"

docker build -t "${IMAGE}:${TAG}" -t "${IMAGE}:latest" .
echo "Built ${IMAGE}:${TAG}"