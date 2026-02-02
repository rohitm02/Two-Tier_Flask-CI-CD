#!/bin/bash
set -e

echo -e "\n\033[1;36m===============================================\033[0m"
echo -e "\033[1;36m   Flask Todo App - Shutdown Script            \033[0m"
echo -e "\033[1;36m===============================================\033[0m\n"

info() { echo -e "\033[1;32m[INFO]\033[0m $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

info "Stopping containers..."

if docker compose version &>/dev/null; then
    docker compose down
else
    docker-compose down
fi

echo -e "\n\033[1;36mContainers stopped. Data preserved in volumes.\033[0m\n"