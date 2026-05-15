#!/bin/bash

set -e

echo "Updating APT..."
sudo apt update && sudo apt upgrade -y

echo "Installing base packages..."
sudo apt install -y \
  git \
  curl \
  wget \
  zsh \
  openssh-server \
  build-essential \
  software-properties-common \
  unzip \
  htop \
  python3-pip \
  python3-venv \
  gnupg \
  lsb-release

echo "Installing VSCode..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
rm microsoft.gpg

echo "Setting zsh as default shell..."
chsh -s $(which zsh)

echo "Done. Reboot to apply shell change."
