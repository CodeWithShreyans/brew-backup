#!/bin/bash

# Backup directory in iCloud Drive 
backup_path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/.brew-backup"

if [ "$1" != "backup" ] && [ "$1" != "restore" ]; then
    printf "Backup and restore your Homebrew packages to iCloud\n\n"
    printf "Usage: brew-backup.sh [backup|restore|help]\n\n"
    echo "backup: Create a backup of installed Homebrew packages"
    echo "restore: Restore from the latest backup"
fi

if [ "$1" == "backup" ]; then
    # Create the backup directory and send output to /dev/null
    mkdir "$backup_path" > /dev/null 2>&1

    file_path="$backup_path/Brewfile-$(date -I seconds | sed "s/+.*//")"

    # Run brew bundle dump and save the Brewfile to the backup_path
    /opt/homebrew/bin/brew bundle dump --file="$file_path"

    echo "Saved Brewfile to $file_path"

    # Loop over all files in backup_path sorted by date created and delete all but the latest 10
    # shellcheck disable=SC2012
    ls -t "$backup_path" | tail -n +11 | xargs -I {} rm "$backup_path/{}"
fi

if [ "$1" == "restore" ]; then
    # Run brew bundle install and point to the Brewfile in the backup_path
    # shellcheck disable=SC2012
    /opt/homebrew/bin/brew bundle install --file="$backup_path/$(ls -t "$backup_path" | head -n 1)"
fi