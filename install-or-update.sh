#!/bin/bash

set -e

# Navigate to the script's directory
cd "$(dirname "$0")"

# Variables
GITHUB_USER="ip7z"
GITHUB_REPO="7zip"
ARTIFACT_PATTERN="linux-x64"

INSTALL_DIR="$(realpath $(dirname "$0"))"
BIN_SYMLINK_7ZZ="/usr/local/bin/7zz"
BIN_SYMLINK_7ZZS="/usr/local/bin/7zzs"
BIN_SYMLINK_7Z="/usr/local/bin/7z"

# Fetch the latest artifact information
echo "Fetching the latest 7zip artifact details..."
ARTIFACT_FILENAME=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-filename)
ARTIFACT_URL=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-url)
ARTIFACT_TAG=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-tag)

if [[ -z "$ARTIFACT_FILENAME" || -z "$ARTIFACT_URL" ]]; then
  echo "ERROR: Unable to fetch the latest 7zip artifact!"
  exit 1
fi

echo "Latest version: $ARTIFACT_TAG ($ARTIFACT_FILENAME)"

# Check if the current version is already installed
if [[ -f 7zip/version.txt ]]; then
  CURRENT_VERSION=$(<7zip/version.txt)
  CURRENT_VERSION=$(echo "$CURRENT_VERSION" | xargs)  # Trim whitespace
  if [[ "$CURRENT_VERSION" == "$ARTIFACT_TAG" ]]; then
    echo "7zip is already up-to-date!"
    exit 0
  fi
fi

# Removing old version
if [[ -d 7zip ]]; then
  echo "Removing old version..."
  rm -rf 7zip
  [ -e 7z ] && rm 7z
  [ -e 7zz ] && rm 7zz
  [ -e 7zzs ] && rm 7zzs
fi

# Download and extract the artifact
./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --download

echo "Installing 7zip..."
mkdir -p 7zip
tar -xf "$ARTIFACT_FILENAME" -C 7zip
echo "$ARTIFACT_TAG" > 7zip/version.txt
rm -f "$ARTIFACT_FILENAME"

# Create symbolic links for 7zz and 7zzs
read -p "Do you want to create symbolic links for 7zz and 7zzs in /usr/local/bin? (y/n): " CONFIRM
if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  echo "Creating symbolic links..."
  sudo ln -sf "$INSTALL_DIR/7zip/7zz" "$BIN_SYMLINK_7ZZ"
  sudo ln -sf "$INSTALL_DIR/7zip/7zzs" "$BIN_SYMLINK_7ZZS"
  echo "Symbolic links for 7zz and 7zzs created successfully."
else
  echo "Symbolic link creation for 7zz and 7zzs skipped."
fi

# Ask to create a symbolic link for 7z pointing to 7zz
read -p "Do you also want to create a 7z symlink pointing to 7zz? (y/n): " CONFIRM
if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  echo "Creating 7z symlink pointing to 7zz..."
  sudo ln -sf "$INSTALL_DIR/7zip/7zz" "$BIN_SYMLINK_7Z"
  echo "7z symlink created successfully."
else
  echo "7z symlink creation skipped."
fi

echo "7zip updated to version $ARTIFACT_TAG successfully!"
