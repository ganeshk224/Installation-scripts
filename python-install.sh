#!/bin/bash

# ✅ Install/Upgrade to latest Python version with pip on Ubuntu
set -e

echo "📦 Checking Ubuntu version..."
OS_VERSION=$(lsb_release -rs)

# ---------------------
# 🧠 Determine latest supported version
# For Ubuntu 24.04: Use default Python 3.12
# For Ubuntu ≤ 22.04: Use Deadsnakes (3.11+)
# ---------------------
if [[ "$OS_VERSION" == "24.04" ]]; then
    echo "🚀 Ubuntu 24.04 detected. Installing/upgrading to Python 3.12 (default)."
    
    sudo apt update -y
    sudo apt install -y python3 python3-pip python3-venv python3-distutils
else
    echo "📦 Ubuntu $OS_VERSION detected. Installing latest supported version (via Deadsnakes)."

    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt update -y
    sudo apt install -y python3.11 python3.11-venv python3.11-distutils

    # Point python3 to python3.11
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
    sudo update-alternatives --set python3 /usr/bin/python3.11

    # Install pip using bootstrap
    curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
fi

# ✅ Final validation
echo "✅ Final Python version: $(python3 --version)"
echo "✅ Final Pip version: $(pip3 --version)"