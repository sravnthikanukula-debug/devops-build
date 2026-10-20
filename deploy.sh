#!/usr/bin/env bash
# Usage: DOCKERHUB_USER=me [DOCKERHUB_TOKEN=xxx] ./deploy.sh <dev|prod> [tag]
set -euo pipefail
export COMPOSE_PROJECT_NAME=devops-build
ENV="${1:?Usage: ./deploy.sh <dev|prod> [tag]}"
export TAG="${2:-latest}"
export IMAGE="${DOCKERHUB_USER:?set DOCKERHUB_USER}/${ENV}"

# prod repo is private, so log in first
if [[ -n "${DOCKERHUB_TOKEN:-}" ]]; then
  echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
fi

docker compose pull
docker compose up -d --remove-orphans
docker image prune -f
docker ps --filter name=react-app