#!/usr/bin/env bash
set -e

SYMLINK_LOCATION="/usr/local/bin"

echo "Checking for existing 7zip symlinks..."

if [[ -e "$SYMLINK_LOCATION/7zz" ]]; then
    echo "Removing $SYMLINK_LOCATION/7zz..."
    sudo rm -f "$SYMLINK_LOCATION/7zz"
fi

if [[ -e "$SYMLINK_LOCATION/7zzs" ]]; then
    echo "Removing $SYMLINK_LOCATION/7zzs..."
    sudo rm -f "$SYMLINK_LOCATION/7zzs"
fi

if [[ -e "$SYMLINK_LOCATION/7z" ]]; then
    echo "Removing $SYMLINK_LOCATION/7z..."
    sudo rm -f "$SYMLINK_LOCATION/7z"
fi

echo "Old symlinks removed (if they existed)."
