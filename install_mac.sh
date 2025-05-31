#!/usr/bin/env zsh
# This script is to quicken the installation of QuickSaveAlias in macOS with Zsh
cd ~/
echo "Installation of QuickSaveAlias for macOS/Zsh Started.."
echo "Downloading QuickSaveAlias for macOS/Zsh.."
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias_mac.sh -o .quicksavealias.sh

# Download any existing aliases. If $1 is not provided it will not download the existing alias. 
# If 'basic' is provided, it will download /my_aliases_bkup/.bash-aliases
# If 'somethingelse' is provided it will download /my_aliases_bkup/.bash-aliases-somethingelse
if [[ "$1" == "basic" ]]; then
    echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases"
    curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases -o .bash-aliases
elif [[ -n "$1" && "$1" != " " ]]; then
    echo "Downloading existing alias backups: loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1"
    curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1 -o .bash-aliases
fi

# The installation of QuickSaveAlias into ~/.zshrc file
if grep -q "quicksavealias.sh -install" ~/.zshrc; then
    echo "QuickSaveAlias already installed in ~/.zshrc"
else
    echo "# Install QuickSaveAlias for the session" >> ~/.zshrc
    echo "[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install" >> ~/.zshrc
fi

# Add the .zsh-aliases loading if it's not already there
if ! grep -q "source ~/.zsh-aliases" ~/.zshrc; then
    echo -e "\n# Load saved aliases" >> ~/.zshrc
    echo "[ -f ~/.zsh-aliases ] && source ~/.zsh-aliases" >> ~/.zshrc
    echo "Added .zsh-aliases loading to ~/.zshrc"
fi

cat << EOF
Installation of QuickSaveAlias completed for macOS/Zsh.
To remove QuickSaveAlias if not needed, remove the QuickSaveAlias install command from ~/.zshrc
Please refer to the link for any details: https://github.com/loganathan001/QuickSaveAlias
EOF
