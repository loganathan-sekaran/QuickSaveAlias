#!/usr/bin/env bash
# This script is to quicken the installation of QuickSaveAlias to do in one command.
cd ~/
echo "Installation of QuickSaveAlias Started.."
echo "Downloading QuickSaveAlias.."
wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias.sh -O .quicksavealias.sh

# Download any existing aliases. If $1 is not provided it will not download the existing alias. 
# If 'basic' is provided, it will download /my_aliases_bkup/.bash-aliases
# If 'somethingelse' is provided it will download /my_aliases_bkup/.bash-aliases-somethingelse
echo "Downloading existing alias backups.."
if [[ "$1" == "basic" ]]; then
	wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases -O .bash-aliases
else if [ ! -z "$1" -a "$1" != " " ]; then
	wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/my_aliases_bkup/.bash-aliases-$1 -O .bash-aliases
fi 

# The installation fo QuickSaveAlias into ~/.bashrc file
cat <<EOT >> .bashrc
# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
EOT

echo "Installation of QuickSaveAlias completed. 
To remove QuickSaveAlias if not needed, remove the QuickSaveAlias install command from ~/.bashrc
Please refer to the link for any details: https://github.com/loganathan001/QuickSaveAlias
"
