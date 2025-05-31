#!/usr/bin/env bash
# This script is to quicken the installation of QuickSaveAlias to do in one command.
cd ~/
echo "Installation of QuickSaveAlias Started.."
echo "Downloading QuickSaveAlias.."
wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias.sh -O .quicksavealias.sh

# Download any existing aliases. If $1 is not provided it will not download the existing alias. 
# If 'basic' is provided, it will download /my_aliases_bkup/.bash-aliases
# If 'somethingelse' is provided it will download /my_aliases_bkup/.bash-aliases-somethingelse
if [[ -n "$1" ]]; then
    # Download the merge script if we need it
    echo "Downloading bash aliases merger..."
    wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/merge_bash_aliases.sh -O .merge_bash_aliases.sh
    chmod +x .merge_bash_aliases.sh

    # Create a backup of existing .bash-aliases if it exists
    if [ -f ~/.bash-aliases ]; then
        cp ~/.bash-aliases ~/.bash-aliases.backup
        echo "Created backup of existing aliases at ~/.bash-aliases.backup"
    fi

    if [[ "$1" == "basic" ]]; then
        echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases"
        # Download to a temporary file
        wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases -O .bash-aliases-temp
        
        # Merge with existing .bash-aliases if it exists
        if [ -f ~/.bash-aliases ]; then
            # Use our merger to preserve existing aliases
            ~/.merge_bash_aliases.sh ~/.bash-aliases-temp ~/.bash-aliases
        else
            # No existing file, just copy directly
            mv .bash-aliases-temp .bash-aliases
        fi
    elif [ ! -z "$1" -a "$1" != " " ]; then
        echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1"
        # Download to a temporary file
        wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1 -O .bash-aliases-temp
        
        # Merge with existing .bash-aliases if it exists
        if [ -f ~/.bash-aliases ]; then
            # Use our merger to preserve existing aliases
            ~/.merge_bash_aliases.sh ~/.bash-aliases-temp ~/.bash-aliases
        else
            # No existing file, just copy directly
            mv .bash-aliases-temp .bash-aliases
        fi
    fi
    
    # Clean up temporary files
    rm -f .bash-aliases-temp
fi

# The installation fo QuickSaveAlias into ~/.bashrc file
cat <<EOT >> .bashrc
# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
EOT

cat << EOF
Installation of QuickSaveAlias completed. 
To remove QuickSaveAlias if not needed, remove the QuickSaveAlias install command from ~/.bashrc
Please refer to the link for any details: https://github.com/loganathan001/QuickSaveAlias
EOF

