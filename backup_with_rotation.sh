#!/bin/bash

# Script Name: backup_with_rotation.sh
# Description: Creates timestamped backups of a specified directory and retains only the last 3 backups.
# Usage: ./backup_with_rotation.sh /path/to/directory

# Check if a directory path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

# Assign the provided directory path to a variable
TARGET_DIR="$1"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Generate a timestamp for the backup folder name
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the backup folder name
BACKUP_DIR="$TARGET_DIR/backup_$TIMESTAMP"

# Create the backup directory
mkdir "$BACKUP_DIR"

# Copy all files from the target directory to the backup directory
cp -r "$TARGET_DIR"/* "$BACKUP_DIR" 2>/dev/null

# Print success message
echo "Backup created: $BACKUP_DIR"

# Implement backup rotation (keep only the last 3 backups)
BACKUPS=($(ls -d "$TARGET_DIR"/backup_* 2>/dev/null | sort -r))  # List backups in reverse order (newest first)

# Check if there are more than 3 backups
if [ ${#BACKUPS[@]} -gt 3 ]; then
    for ((i=3; i<${#BACKUPS[@]}; i++)); do
        rm -rf "${BACKUPS[$i]}"  # Remove the oldest backup
        echo "Old backup removed: ${BACKUPS[$i]}"
    done
fi

exit 0

