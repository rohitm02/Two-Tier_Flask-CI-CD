#!/bin/bash
set -e

echo -e "\n\033[1;36m===============================================\033[0m"
echo -e "\033[1;36m   Flask Todo App - Startup Script             \033[0m"
echo -e "\033[1;36m===============================================\033[0m\n"

info() { echo -e "\033[1;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

info "Project root: $PROJECT_ROOT"

# Checks
[[ ! -f ".env" ]] && { error ".env not found. Copy from .env.example"; exit 1; }
[[ ! -f "docker-compose.yml" ]] && { error "docker-compose.yml not found"; exit 1; }

info "Starting application..."

if docker compose version &>/dev/null; then
    docker compose up -d --build
else
    docker-compose up -d --build
fi

info "Containers started!"
docker ps

echo -e "\n\033[1;36mAccess: http://localhost\033[0m\n"