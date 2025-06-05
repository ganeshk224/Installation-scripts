#!/bin/bash

# This installs the Dokcer, python with PIP and Ansible packages.

set -e

echo "-----------------------------------"
echo " 1. ✅ DOCKER INSTALL/UPGRADE "
echo " 2. ✅ PYTHON INSTALL/UPGRADE "
echo " 3. ✅ ANSIBLE INSTALL/UPGRADE "
echo "-----------------------------------"

echo "🔍 Checking system requirements..."

# ****************** DOCKER *********************
# Step 1: Checking Docker 
echo " First Step: Checking Docker..."

# Check whether Docker is installed
# -----------------------------------
# ✅ DOCKER INSTALL/UPGRADE LOGIC
# -----------------------------------
echo "🔍 Checking Docker installation..."

DOCKER_SCRIPT="docker-install.sh"
DOCKER_SCRIPT_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/docker-install.sh"  # Replace

if command -v docker &> /dev/null; then
    echo "🔁 Docker is already installed: $(docker --version)"
    echo "🔁 Running Docker install script to ensure it's the latest version..."
else
    echo "❌ Docker is not installed. Installing..."
fi

# Download script if not present
if [ ! -f "./$DOCKER_SCRIPT" ]; then
    echo "🌐 Downloading $DOCKER_SCRIPT..."
    curl -fsSL -o "$DOCKER_SCRIPT" "$DOCKER_SCRIPT_URL"
fi

chmod +x "$DOCKER_SCRIPT"
./"$DOCKER_SCRIPT"


#End Of Docker checking


# ****************** Python Installation *********************
# Step 1: Checking Python 
echo " Second Step: Checking Python..."


# Check whether Python is installed
# -----------------------------------
# ✅ PYTHON INSTALL/UPGRADE LOGIC
# -----------------------------------
echo "🔍 Checking Python installation..."

PYTHON_INSTALL_SCRIPT="python-install.sh"
PYTHON_DOWNLOAD_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/python-install.sh"  # Replace with your URL

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    echo "🔍 Current Python version: $PYTHON_VERSION"

    # Always upgrade to latest
    echo "🔁 Python is installed but may not be latest. Running upgrade script..."
else
    echo "❌ Python is not installed. Running install script..."
fi

# 🧠 If file not present, download
if [ ! -f "./$PYTHON_INSTALL_SCRIPT" ]; then
    echo "🌐 Downloading $PYTHON_INSTALL_SCRIPT..."
    curl -fsSL -o "$PYTHON_INSTALL_SCRIPT" "$PYTHON_DOWNLOAD_URL"
fi

# ✅ Run the script regardless of Python status
chmod +x "$PYTHON_INSTALL_SCRIPT"
./"$PYTHON_INSTALL_SCRIPT"

#End Of Pythin checking

# ****************** Ansible Installation *********************
# Step 1: Checking Ansible 
echo " Last Step: Checking Ansible..."


# Check whether Ansible is installed
# -----------------------------------
# ✅ ANSIBLE INSTALL/UPGRADE LOGIC
# -----------------------------------

echo "🔍 Checking Ansible installation..."

ANSIBLE_SCRIPT="ansible-install.sh"
ANSIBLE_SCRIPT_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/ansible-install.sh"  # Replace
MIN_ANSIBLE_VERSION="2.15"

if command -v ansible &> /dev/null; then
    INSTALLED_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    echo "✅ Ansible version $INSTALLED_VERSION is installed."

    LOWEST_VERSION=$(printf '%s\n' "$MIN_ANSIBLE_VERSION" "$INSTALLED_VERSION" | sort -V | head -n1)
    if [ "$LOWEST_VERSION" != "$MIN_ANSIBLE_VERSION" ]; then
        echo "⚠️ Ansible version is below $MIN_ANSIBLE_VERSION, upgrading..."
        RUN_INSTALL=1
    else
        echo "✅ Ansible version meets minimum requirement. Skipping install."
        RUN_INSTALL=0
    fi
else
    echo "❌ Ansible is not installed. Installing..."
    RUN_INSTALL=1
fi

if [ "$RUN_INSTALL" -eq 1 ]; then
    if [ -f "./$ANSIBLE_SCRIPT" ]; then
        echo "📂 $ANSIBLE_SCRIPT already exists. Skipping download."
    else
        echo "🌐 Downloading $ANSIBLE_SCRIPT..."
        curl -fsSL -o "$ANSIBLE_SCRIPT" "$ANSIBLE_SCRIPT_URL"
    fi

    chmod +x "$ANSIBLE_SCRIPT"
    ./"$ANSIBLE_SCRIPT"
fi
