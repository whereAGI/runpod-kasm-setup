#!/bin/bash

# Function to log messages with timestamps
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling
set -e
trap 'log_message "Error occurred at line $LINENO. Exit code: $?"' ERR

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    log_message "Please run as root"
    exit 1
fi

# Update package list
log_message "Updating package list..."
apt-get update

# Install dependencies
log_message "Installing dependencies..."
apt-get install -y \
    curl \
    wget \
    gpg \
    software-properties-common \
    apt-transport-https

# Install VS Code
log_message "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt-get update
apt-get install -y code

# Configure user permissions
log_message "Configuring user permissions..."
echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set environment variables
log_message "Setting environment variables..."
cat >> /etc/environment << EOF
NVIDIA_VISIBLE_DEVICES=all
NVIDIA_DRIVER_CAPABILITIES=all
EOF

# Modify KASM startup scripts
log_message "Modifying KASM startup scripts..."
sed -i "s/USER_NAME=.*/USER_NAME=root/g" /dockerstartup/kasm_default_profile.sh
sed -i "s/sudo -u .*/exec \"\$@\"/g" /dockerstartup/kasm_startup.sh

# Clean up
log_message "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

log_message "Setup completed successfully!"