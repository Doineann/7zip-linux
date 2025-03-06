#!/bin/bash

set -e

# Variables
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)/7zip"  # Install directory is ./7zip relative to the script
BIN_SYMLINK_7ZZ="/usr/local/bin/7zz"
BIN_SYMLINK_7ZZS="/usr/local/bin/7zzs"
BIN_SYMLINK_7Z="/usr/local/bin/7z"

echo "Uninstalling 7zip..."

# Step 1: Remove symbolic links
echo "Removing symbolic links..."
for SYMLINK in "$BIN_SYMLINK_7ZZ" "$BIN_SYMLINK_7ZZS" "$BIN_SYMLINK_7Z"; do
  if [[ -L "$SYMLINK" ]]; then
    echo "Removing symbolic link: $SYMLINK"
    sudo rm -f "$SYMLINK"
    if [[ $? -eq 0 ]]; then
      echo "Symbolic link $SYMLINK removed successfully."
    else
      echo "ERROR: Failed to remove symbolic link $SYMLINK!"
      exit 1
    fi
  else
    echo "No symbolic link found at $SYMLINK."
  fi
done

# Step 2: Remove the installation directory
if [[ -d "$INSTALL_DIR" ]]; then
  echo "Removing installation directory at $INSTALL_DIR..."
  rm -rf "$INSTALL_DIR"
  if [[ $? -eq 0 ]]; then
    echo "Installation directory removed successfully."
  else
    echo "ERROR: Failed to remove the installation directory!"
    exit 1
  fi
else
  echo "No installation directory found at $INSTALL_DIR."
fi

echo "7zip uninstalled successfully!"
