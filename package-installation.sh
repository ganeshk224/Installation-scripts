#!/bin/bash

# This installs the Dokcer, python with PIP and Ansible packages.

set -e

echo "-----------------------------------"
echo " 1. ✅ DOCKER INSTALL/UPGRADE "
echo " 2. ✅ PYTHON INSTALL/UPGRADE "
echo " 3. ✅ ANSIBLE INSTALL/UPGRADE "
echo "-----------------------------------"

echo "🔍 Checking system requirements..."

LOG_FILE="installation_log_$(date +%F).txt"
if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
else
    touch "$LOG_FILE"
fi 

echo " ****************** DOCKER *********************"
# Check whether Docker is installed
# -----------------------------------
# ✅ DOCKER INSTALL/UPGRADE LOGIC
# -----------------------------------
echo "🔍 Checking Docker installation..."

DOCKER_SCRIPT="docker-install.sh"
DOCKER_SCRIPT_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/docker-install.sh"  # Replace

if command -v docker &> /dev/null; then
    DOCKER_VERSION="$(docker --version | awk '{print $3}' | sed 's/,//')"
    MIN_DOCKER_VERSION="24.0.5"
    RUN_INSTALL=0

    if dpkg --compare-versions "$DOCKER_VERSION" ge "$MIN_DOCKER_VERSION"; then
        echo "✅ Docker version ($DOCKER_VERSION) is greater than minimum required ($MIN_DOCKER_VERSION)."
    else
        echo "❌ Minimum Docker version ($MIN_DOCKER_VERSION) is greater or equal to current version ($DOCKER_VERSION). Running upgrade..."
        RUN_INSTALL=1
    fi
else
    echo "❌ Docker is not installed. Installing Docker ..."
    RUN_INSTALL=1
fi

if [ "$RUN_INSTALL" -eq 1 ]; then
    if [ -f "./$DOCKER_SCRIPT" ]; then
        echo "📂 $DOCKER_SCRIPT already exists. Skipping download. Installing Docker... ⏳"
    else
        echo "🌐 Downloading $DOCKER_SCRIPT..."
        echo " $DOCKER_SCRIPT downloaded, Installing Docker... ⏳"
        curl -fsSL -o "$DOCKER_SCRIPT" "$DOCKER_SCRIPT_URL"
    fi

    chmod +x "$DOCKER_SCRIPT"
    ./"$DOCKER_SCRIPT" >> $PWD/$LOG_FILE

    sleep 5
    if command -v docker &> /dev/null; then
        echo " Docker is installed !!, Removing the installation file from server."
        rm -rf "$DOCKER_SCRIPT" &> /dev/null
    else
        echo " Docker installation failed !! Check the Installation log file $PWD/$LOG_FILE ."
    fi
fi

#End Of Docker checking

echo " ****************** Python Installation *********************"
# Check whether Python is installed
# -----------------------------------
# ✅ PYTHON INSTALL/UPGRADE LOGIC
# -----------------------------------
echo "🔍 Checking Python installation..."

PYTHON_INSTALL_SCRIPT="python-install.sh"
PYTHON_DOWNLOAD_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/python-install.sh" 

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    MIN_PYTHON_VERSION="3.11"
    RUN_INSTALL=0
    # Compare version strings using sort -V
    if [ "$(printf '%s\n' "$MIN_PYTHON_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$MIN_PYTHON_VERSION" ] && [ "$PYTHON_VERSION" != "$MIN_PYTHON_VERSION" ]; then
        echo "✅ Python version ($PYTHON_VERSION) is greater than minimum required ($MIN_PYTHON_VERSION)."
    else
        echo "❌ Minimum Python version ($MIN_PYTHON_VERSION) is greater or equal to current version ($PYTHON_VERSION). Running upgrade..."
         RUN_INSTALL=1
    fi
else
    echo "❌ Python not found on system. Running install script..."
    RUN_INSTALL=1
fi

if [ "$RUN_INSTALL" -eq 1 ]; then
    if [ -f "./$PYTHON_INSTALL_SCRIPT" ]; then
        echo "📂 $PYTHON_INSTALL_SCRIPT already exists. Skipping download. Installing Python... ⏳"
    else
        echo "🌐 Downloading $PYTHON_INSTALL_SCRIPT..."
        echo " $PYTHON_INSTALL_SCRIPT downloaded, Installing Python... ⏳"
        curl -fsSL -o "$PYTHON_INSTALL_SCRIPT" "$PYTHON_DOWNLOAD_URL"
    fi

    chmod +x "$PYTHON_INSTALL_SCRIPT"
    ./"$PYTHON_INSTALL_SCRIPT" >> $PWD/$LOG_FILE

    sleep 5

    if command -v python3 &> /dev/null; then
        echo " Python is installed !!, Removing the installation file from server"
        rm -rf "$PYTHON_INSTALL_SCRIPT" &> /dev/null
    else
        echo " Python installation failed !! Check the Installation log file under $PWD"
    fi

fi

#End Of Python checking

echo "  ****************** Ansible Installation *********************"
# Check whether Ansible is installed
# -----------------------------------
# ✅ ANSIBLE INSTALL/UPGRADE LOGIC
# -----------------------------------

echo "🔍 Checking Ansible installation..."

ANSIBLE_SCRIPT="ansible-install.sh"
ANSIBLE_SCRIPT_URL="https://raw.githubusercontent.com/ganeshk224/Installation-scripts/master/ansible-install.sh"

if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1 | awk '{print $3}'| sed 's/]//')
    RUN_INSTALL=0
    MIN_ANSIBLE_VERSION="2.15"
    if [ "$(printf '%s\n' "$MIN_ANSIBLE_VERSION" "$ANSIBLE_VERSION" | sort -V | head -n1)" = "$MIN_ANSIBLE_VERSION" ] && [ "$ANSIBLE_VERSION" != "$MIN_ANSIBLE_VERSION" ]; then
        echo "✅ Ansible version ($ANSIBLE_VERSION) is greater than minimum required ($MIN_ANSIBLE_VERSION)."
    else
        echo "❌ Minimum Ansible version ($MIN_ANSIBLE_VERSION) is greater or equal to current version ($ANSIBLE_VERSION). Running upgrade..."
         RUN_INSTALL=1
    fi

else
    echo "❌ Ansible not found on system. Running install script..."
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
    ./"$ANSIBLE_SCRIPT" >> $PWD/$LOG_FILE

    sleep 5

    if command -v ansible &> /dev/null; then
        echo " Ansible is installed !!, Removing the installation file from server."
        rm -rf "$ANSIBLE_SCRIPT" &> /dev/null
    else
        echo " Ansible installation failed !! Check the Installation log file $PWD/$LOG_FILE ."
    fi
fi
#End Of Ansible checking
