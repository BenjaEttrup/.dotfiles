#!/bin/bash

# Exit on error
set -e

# Source Util functions
source utils.sh

if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

echo "Starting..."

# Update the system
echo "Updating the system..."
sudo pacman -Syu --noconfirm

# Install yay
if ! command -v yay &>/dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  echo "Building yay..."
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "Yay is already installed"
fi

# Install packages
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing dev tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing desktop environment..."
install_packages "${DESKTOP_ENVIRONMENT[@]}"

echo "Installing personal packages..."
install_packages "${PERSONAL[@]}"

echo "Setup complete! You may want to reboot your system."
