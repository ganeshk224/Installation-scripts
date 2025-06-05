#!/bin/bash

# 🚀 Docker Install or Upgrade Script for Ubuntu 24.04+
set -e

echo "📦 Updating package index..."
sudo apt update -y

echo "🔍 Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# ✅ Set up Docker's official GPG key if not already
DOCKER_KEYRING="/usr/share/keyrings/docker-archive-keyring.gpg"
if [ ! -f "$DOCKER_KEYRING" ]; then
    echo "🔐 Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o "$DOCKER_KEYRING"
fi

# ✅ Add Docker repo if not already added
DOCKER_LIST="/etc/apt/sources.list.d/docker.list"
if ! grep -q "download.docker.com" "$DOCKER_LIST" 2>/dev/null; then
    echo "➕ Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_KEYRING] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee "$DOCKER_LIST" > /dev/null
fi

echo "🔄 Updating package list..."
sudo apt update -y

# ✅ Install or upgrade Docker
echo "📥 Installing/Upgrading Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ✅ Confirm
echo "✅ Docker installed: $(docker --version)"