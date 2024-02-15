#!/bin/bash

# Backup directory in iCloud Drive 
backup_path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/.brew-backup"

# Create the backup directory and send output to /dev/null
mkdir "$backup_path" > /dev/null 2>&1

# Run brew bundle dump and save the Brewfile to the backup_path
/opt/homebrew/bin/brew bundle dump --file="$backup_path/Brewfile-$(date -I seconds | sed "s/+.*//")"

# Loop over all files in backup_path sorted by date created and delete all but the latest 10
# shellcheck disable=SC2012
ls -t "$backup_path" | tail -n +11 | xargs -I {} rm "$backup_path/{}"