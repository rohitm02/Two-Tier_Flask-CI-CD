#!/bin/bash
set -e

# Banner

echo -e "\n\033[1;36m===============================================\033[0m"
echo -e "\033[1;36m   Flask + MySQL CI/CD Demo – Installer         \033[0m"
echo -e "\033[1;36m   (Docker + Compose on EC2)                    \033[0m"
echo -e "\033[1;36m===============================================\033[0m\n"

# Logging helpers

info() { echo -e "\033[1;32m[INFO]\033[0m $1"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# OS Detection

info "Detecting operating system..."

if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect OS (missing /etc/os-release)"
    exit 1
fi

. /etc/os-release

case "$ID" in
ubuntu | debian)
    PKG=apt
    ;;
amzn | rhel | centos | almalinux | rocky)
    PKG=yum
    ;;
opensuse* | sles)
    PKG=zypper
    ;;
*)
    error "Unsupported OS: $ID"
    exit 1
    ;;
esac

info "Detected OS: $PRETTY_NAME"
info "Using package manager: $PKG"

# System Update

info "Updating system packages..."

case $PKG in
apt)
    sudo apt update -y
    ;;
yum)
    sudo yum update -y
    ;;
zypper)
    sudo zypper refresh
    ;;
esac

# Docker Installation

if command -v docker &>/dev/null; then
    info "Docker already installed"
else
    info "Installing Docker..."

    case $PKG in
    apt)
        sudo apt install -y docker.io
        ;;
    yum)
        sudo yum install -y docker
        ;;
    zypper)
        sudo zypper install -y docker
        ;;
    esac

    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Docker Permissions

info "Configuring Docker permissions..."

if groups "$USER" | grep -q docker; then
    info "User already in docker group"
else
    sudo usermod -aG docker "$USER"
    warn "Docker group added. Log out and log back in required."
fi

# Docker Compose Installation

if docker compose version &>/dev/null; then
    info "Docker Compose already installed"
else
    info "Installing Docker Compose plugin..."

    curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o docker-compose
    chmod +x docker-compose
    sudo mv docker-compose /usr/local/bin/docker-compose
fi

# Validation

info "Validating installations..."

docker --version
docker-compose --version
systemctl status docker --no-pager

# Completion

echo -e "\n\033[1;36m===============================================\033[0m"
echo -e "\033[1;36m Installation Complete                         \033[0m"
echo -e "\033[1;36m-----------------------------------------------\033[0m"
echo -e "\033[1;36m Next Steps:                                   \033[0m"
echo -e "\033[1;36m 1. Log out & log back in (Docker permissions) \033[0m"
echo -e "\033[1;36m 2. Create .env file (copy from .env.example)  \033[0m"
echo -e "\033[1;36m 3. Run ./scripts/start.sh                     \033[0m"
echo -e "\033[1;36m===============================================\033[0m\n"