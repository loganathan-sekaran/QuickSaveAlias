#!/usr/bin/env zsh
# This script is to quicken the installation of QuickSaveAlias in macOS with Zsh
cd ~/
echo "Installation of QuickSaveAlias for macOS/Zsh Started.."
echo "Downloading QuickSaveAlias for macOS/Zsh.."
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias_mac.sh -o .quicksavealias.sh
echo "Downloading helper script for special character aliases.."
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/zsh_special_aliases.sh -o .zsh_special_aliases.sh
chmod +x .zsh_special_aliases.sh

# Download any existing aliases. If $1 is not provided it will not download the existing alias. 
# If 'basic' is provided, it will download /my_aliases_bkup/.bash-aliases
# If 'somethingelse' is provided it will download /my_aliases_bkup/.bash-aliases-somethingelse
if [[ -n "$1" ]]; then
    # Download the converter script if it doesn't exist locally
    if [ ! -f ~/.convert_bash_aliases.sh ]; then
        echo "Downloading bash to zsh alias converter..."
        curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/convert_bash_aliases.sh -o ~/.convert_bash_aliases.sh
        chmod +x ~/.convert_bash_aliases.sh
    fi

    # Create a backup of existing .zsh-aliases if it exists
    if [ -f ~/.zsh-aliases ]; then
        cp ~/.zsh-aliases ~/.zsh-aliases.backup
        echo "Created backup of existing aliases at ~/.zsh-aliases.backup"
    fi

    # Handle different types of backups
    if [[ "$1" == "basic" ]]; then
        echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases"
        # Download to a temporary file
        curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases -o ~/.bash-aliases-temp
        
        # Convert and merge with existing .zsh-aliases
        ~/.convert_bash_aliases.sh ~/.bash-aliases-temp ~/.zsh-aliases
        
        # Clean up
        rm ~/.bash-aliases-temp
    elif [[ "$1" != " " ]]; then
        echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1"
        # Download to a temporary file
        curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1 -o ~/.bash-aliases-temp
        
        # Convert and merge with existing .zsh-aliases
        ~/.convert_bash_aliases.sh ~/.bash-aliases-temp ~/.zsh-aliases
        
        # Clean up
        rm ~/.bash-aliases-temp
    fi
fi

# The installation of QuickSaveAlias into ~/.zshrc file
if grep -q "quicksavealias.sh -install" ~/.zshrc; then
    echo "QuickSaveAlias already installed in ~/.zshrc"
else
    echo "# Install QuickSaveAlias for the session" >> ~/.zshrc
    echo "[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install" >> ~/.zshrc
fi

# Remove direct .zsh-aliases loading if it exists
if grep -q "source ~/.zsh-aliases" ~/.zshrc; then
    sed -i '' '/source ~\/.zsh-aliases/d' ~/.zshrc
fi

# Add the special aliases loader if it's not already there
if ! grep -q "source ~/.zsh_special_aliases.sh" ~/.zshrc; then
    echo -e "\n# Load all aliases including special character aliases" >> ~/.zshrc
    echo "[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh" >> ~/.zshrc
    echo "Added special alias loading helper to ~/.zshrc"
fi

# Run initial synchronization of special character aliases if we have an existing file
if [ -f ~/.zsh-aliases ]; then
    echo "Running initial synchronization of special character aliases..."
    source ~/.quicksavealias.sh -install
    echo "Synchronization complete."
fi

cat << EOF
Installation of QuickSaveAlias completed for macOS/Zsh.

Special character aliases (like '-', '...', etc.) are now handled automatically
through a special helper script. To fix any alias issues, run:
   source ~/.quicksavealias.sh -install && fixal

To remove QuickSaveAlias if not needed, remove the QuickSaveAlias install command from ~/.zshrc
Please refer to the link for any details: https://github.com/loganathan001/QuickSaveAlias
EOF
