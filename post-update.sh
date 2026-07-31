#!/usr/bin/env bash
set -e

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)/7zip"
SYMLINK_LOCATION="/usr/local/bin"

echo "7zip installation complete."

# Ask for symlink creation (7zz + 7zzs)
read -p "Do you want to create symbolic links for 7zz and 7zzs in $SYMLINK_LOCATION? (y/n): " CONFIRM
if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
    echo "Creating symbolic links..."
    sudo ln -sf "$INSTALL_DIR/7zz" "$SYMLINK_LOCATION/7zz"
    sudo ln -sf "$INSTALL_DIR/7zzs" "$SYMLINK_LOCATION/7zzs"
    echo "Symbolic links for 7zz and 7zzs created successfully."
else
    echo "Symbolic link creation for 7zz and 7zzs skipped."
fi

# Ask to create a symbolic link for 7z pointing to 7zz
read -p "Do you also want to create a 7z symlink pointing to 7zz? (y/n): " CONFIRM2
if [[ "$CONFIRM2" == "y" || "$CONFIRM2" == "Y" ]]; then
    echo "Creating 7z symlink pointing to 7zz..."
    sudo ln -sf "$INSTALL_DIR/7zz" "$SYMLINK_LOCATION/7z"
    echo "7z symlink created successfully."
else
    echo "7z symlink creation skipped."
fi

echo "7zip updated successfully."
