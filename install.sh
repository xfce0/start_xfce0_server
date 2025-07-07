#!/bin/bash

# Terminal, Vim, Tmux, SSH Setup Script
# Created by Claude
# This script installs and configures terminal customizations for Linux/macOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    # Check if running in Termux
    if [ -n "$TERMUX_VERSION" ]; then
        OS="Termux"
    fi
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${GREEN}Detected OS: $OS${NC}"

# Directories
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/configs"
BACKUP_DIR="$HOME/.terminal_backups/$(date +%Y%m%d%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${BLUE}Created backup directory: $BACKUP_DIR${NC}"

# Function to backup existing file
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -d "$file" ]; then
        cp -r "$file" "$BACKUP_DIR/"
        echo -e "${YELLOW}Backed up: $file${NC}"
    fi
}

# Function to install a config file
install_config() {
    local src="$1"
    local dest="$2"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    # Backup existing file
    backup_file "$dest"
    
    # Copy the config file
    cp -f "$src" "$dest"
    echo -e "${GREEN}Installed: $dest${NC}"
}

echo -e "${BLUE}=== Installing configurations ===${NC}"

# Install Vim configuration
install_config "$CONFIG_DIR/vimrc" "$HOME/.vimrc"

# Install Tmux configuration
install_config "$CONFIG_DIR/tmux.conf" "$HOME/.tmux.conf"

# Install SSH configuration
if [ "$OS" = "Termux" ]; then
    SSH_CONFIG_DIR="$HOME/.ssh"
else
    SSH_CONFIG_DIR="$HOME/.ssh"
fi

mkdir -p "$SSH_CONFIG_DIR"
install_config "$CONFIG_DIR/ssh_config" "$SSH_CONFIG_DIR/config"

# Install SSH welcome banner
if [ "$OS" = "Linux" ]; then
    # For Linux, copy to /etc/ssh with sudo
    echo -e "${YELLOW}Installing SSH welcome banner (may require sudo password)${NC}"
    sudo cp -f "$CONFIG_DIR/motd.txt" "/etc/motd"
    sudo cp -f "$CONFIG_DIR/xfce0_banner.txt" "/etc/ssh/xfce0_banner"
    
    # Configure sshd to use the banner if not already done
    if ! grep -q "Banner /etc/ssh/xfce0_banner" /etc/ssh/sshd_config; then
        echo -e "${YELLOW}Updating sshd_config to use banner (may require sudo password)${NC}"
        echo "Banner /etc/ssh/xfce0_banner" | sudo tee -a /etc/ssh/sshd_config > /dev/null
    fi
elif [ "$OS" = "macOS" ]; then
    # For macOS, enable SSH and configure banner
    echo -e "${YELLOW}Configuring SSH on macOS (may require sudo password)${NC}"
    sudo cp -f "$CONFIG_DIR/xfce0_banner.txt" "/etc/ssh_banner"
    
    # Check if SSH is enabled
    if ! sudo systemsetup -getremotelogin | grep -q "On"; then
        echo -e "${YELLOW}Enabling SSH (may require sudo password)${NC}"
        sudo systemsetup -setremotelogin on
    fi
    
    # Configure sshd to use the banner if not already done
    if ! grep -q "Banner /etc/ssh_banner" /etc/ssh/sshd_config; then
        echo -e "${YELLOW}Updating sshd_config to use banner (may require sudo password)${NC}"
        echo "Banner /etc/ssh_banner" | sudo tee -a /etc/ssh/sshd_config > /dev/null
    fi
elif [ "$OS" = "Termux" ]; then
    # For Termux, copy to termux directory
    mkdir -p "$HOME/.termux"
    install_config "$CONFIG_DIR/motd.txt" "$HOME/.termux/motd.txt"
    install_config "$CONFIG_DIR/xfce0_banner.txt" "$HOME/.termux/banner.txt"
fi

# Install shell configuration
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
    SHELL_TYPE="bash"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
    SHELL_TYPE="zsh"
else
    # Create bash profile if none exists
    SHELL_RC="$HOME/.bashrc"
    SHELL_TYPE="bash"
    touch "$SHELL_RC"
fi

echo -e "${BLUE}Detected shell: $SHELL_TYPE${NC}"
backup_file "$SHELL_RC"

# Add shell customizations to shell RC file
cat "$CONFIG_DIR/shell_prompt.sh" >> "$SHELL_RC"
echo -e "${GREEN}Updated shell configuration: $SHELL_RC${NC}"

# Configure Termux if detected
if [ "$OS" = "Termux" ]; then
    echo -e "${BLUE}Configuring Termux${NC}"
    install_config "$CONFIG_DIR/termux.properties" "$HOME/.termux/termux.properties"
    
    # Reload Termux settings
    termux-reload-settings
fi

echo -e "${GREEN}=== Installation complete! ===${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source $SHELL_RC' to apply changes.${NC}"
echo -e "${BLUE}Your previous configurations have been backed up to: $BACKUP_DIR${NC}"
echo -e "${GREEN}Enjoy your new terminal experience!${NC}"