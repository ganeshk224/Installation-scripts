#!/bin/bash

# 🚀 Ansible Install/Upgrade Script for Ubuntu 20.04–24.04
set -e

echo "📦 Updating package index..."
sudo apt update -y

echo "🔧 Installing utility for managing repositories..."
sudo apt install -y software-properties-common

# ➕ Add Ansible PPA if not already added
if ! grep -q "^deb .\+ansible" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
    echo "➕ Adding Ansible PPA..."
    sudo add-apt-repository --yes --update ppa:ansible/ansible
else
    echo "✅ Ansible PPA already added."
fi

# 📥 Install or upgrade Ansible
echo "📥 Installing or upgrading Ansible..."
sudo apt update -y
sudo apt install -y ansible

# ✅ Confirm installation
if command -v ansible &> /dev/null; then
    echo "✅ Ansible installed successfully: $(ansible --version | head -n 1)"
else
    echo "❌ Ansible installation failed."
    exit 1
fi
