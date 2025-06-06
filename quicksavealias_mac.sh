#!/usr/bin/env zsh
#
# Quick Save Alias (Zsh version for macOS)
#
# Author:Loganathan.S github.com/loganathan001
#

## Global Declarations
#

#constants
QSA_SCRIPT_VERSION='1.1.0'

#Aliases
# Simple version for Zsh that just writes aliases directly to a file
alias sval='
  # Save all current aliases to the file
  alias > $ZSH_ALIAS_FILE_PATH
  echo "Aliases saved to $ZSH_ALIAS_FILE_PATH"
  # Synchronize special character aliases to the helper script
  syncSpecialAliases
'

## Declare other constants
qsa_declare_constants() {
	ZSH_ALIAS_FILE_PATH=~/.zsh-aliases
	ALIAS_FUNC_PREFIX=alfunc_
}

qsa_show_help() {
	#Info about Quick Save Alias
	about_qsa
	#Installation Guide
	qsa_installation_guide
	#Usage Guide
	qsa_usage_guide
}

about_qsa() {
cat << EOF

Quick Save Alias - Version $QSA_SCRIPT_VERSION (Zsh/macOS)
==================================
Used to quickly add, remove, change aliases and alias functions which will be persisted for future use automatically.

Note: This feature will be applied only for the particular user where it is installed.

Alias Functions:
----------------
Alias functions are functions with single line statements that can accept function arguments, stored as alias.

EOF
}

qsa_installation_guide() {
cat << EOF

Installing:
-----------

To install the script for the session, copy the following code to ~/.zshrc:

# Install QuickSaveAlias for the session
[ -e ~/quicksavealias.sh ] && source quicksavealias.sh -install

Hint: You can copy the file to home directory and make the file hidden by prefixing by period and then install as below

# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install


Un-installing:
-------------
Just remove the entries added for installing the feature in ~/.zshrc:
* The line with "quicksavealias.sh -install"
* The line with "source ~/.zsh-aliases"

Note: 
* The installer automatically adds the necessary line to load your saved aliases from ~/.zsh-aliases
* To reuse the aliases created, across multiple installations, multiple users and multiple machines, 
have a backup of the file ~/.zsh-aliases and copy it to the home directory before installing the script as above. 
* To remove all the new aliases created just delete ~/.zsh-aliases file

EOF
}

alh() {
	#Info about Quick Save Alias
	about_qsa
	#Usage Guide
	qsa_usage_guide
}

# Fix broken aliases file by converting it to the proper format
fixal() {
	if [ -f $ZSH_ALIAS_FILE_PATH ]; then
		echo "Fixing the format of aliases in $ZSH_ALIAS_FILE_PATH..."
		
		# Create backup before fixing
		cp $ZSH_ALIAS_FILE_PATH $ZSH_ALIAS_FILE_PATH.bak
		echo "Created backup at $ZSH_ALIAS_FILE_PATH.bak"
		
		# Create a temporary file
		local tmp_file=$(mktemp)
		echo "# filepath: $ZSH_ALIAS_FILE_PATH (fixed format)" > $tmp_file
		
		# Process the file line by line
		cat $ZSH_ALIAS_FILE_PATH | while IFS= read -r line; do
			# Skip empty lines
			if [[ -z "$line" ]]; then
				continue
			fi
			
			# Handle comments
			if [[ "$line" == \#* ]]; then
				echo "$line" >> $tmp_file
				continue
			fi
			
			# Skip lines that already have proper "alias " prefix
			if [[ "$line" == alias* && "$line" != *"="* ]]; then
				echo "$line" >> $tmp_file
				continue
			fi
			
			# Process alias definitions
			if [[ "$line" == *"="* ]]; then
				# If already has alias prefix, extract just the name and value
				if [[ "$line" == alias* ]]; then
					# Remove the 'alias ' prefix
					line=${line#alias }
					# Remove surrounding quotes if present
					line=$(echo "$line" | sed -E "s/^['\"](.*)['\"]$/\\1/")
				fi
				
				# Extract the alias name (everything before first =)
				alias_name=$(echo "$line" | sed -E "s/^([^=]+)=.*/\\1/")
				
				# Check if it needs special handling
				if [[ "$alias_name" == -* || "$alias_name" == .* || "$alias_name" == [0-9]* || 
					  "$alias_name" == *-* || "$alias_name" == *+* || "$alias_name" == *\** || 
					  "$alias_name" == *\!* || "$alias_name" == *\&* ]]; then
					# Quote the entire alias for special characters
					echo "alias '$line'" >> $tmp_file
				else
					# Regular alias
					echo "alias $line" >> $tmp_file
				fi
			else
				# Just keep other lines as they are
				echo "$line" >> $tmp_file
			fi
		done
		
		# Replace the original file with the fixed one
		mv $tmp_file $ZSH_ALIAS_FILE_PATH
		echo "Aliases fixed. Please restart your shell or run 'source $ZSH_ALIAS_FILE_PATH'"
	else
		echo "No aliases file found at $ZSH_ALIAS_FILE_PATH"
	fi
}

qsa_usage_guide() {
cat << EOF

Usage:
======

Utility functions:
------------------
	adal	<alias name> <alias value>		: To add an alias and persist the change.
	rmal	<alias name> <alias value>		: To remove an alias and persist the change.
	chal	<alias name> <alias value>		: To change an alias and persist the change.
	cpal	<old alias name> <new alias name>	: Copy an old alias to a new alias name and persist the change.
	mval	<old alias name> <new alias name>	: Rename an old alias with a new name and persist the change.
	
	adfn	<function name> <function value>		: To add an alias function and persist the change. This function can have arguments like \$1, \$2.
	rmfn	<function name> <function value>		: To remove an alias function and persist the change. This function can have arguments like \$1, \$2.
	chfn	<function name> <function value>		: To change an alias function and persist the change. This function can have arguments like \$1, \$2.
	cpfn	<old function name> <new function name>		: Copy an old alias function to a new alias function name and persist the change. This function can have arguments like \$1, \$2.
	mvfn	<old function name> <new function name>		: Rename an old alias function with a new name and persist the change. This function can have arguments like \$1, \$2.

	alh	: To show this usage.


Aliases:
--------
	al                                      : Shortcut for 'alias'
	unal                                    : Shortcut for 'unalias'
	lsal                                    : Shorcut for 'alias' - used to list the aliases
	sval                                    : Saves all the aliases to '$ZSH_ALIAS_FILE_PATH' for future usage.
	algrep [grep_options] GREP_PATTERN      : used to find the alias based on the grep pattern.
	
	lsfn                                    : list all alias functions
	fngrep [grep_options] GREP_PATTERN      : used to find the alias functions based on the grep pattern.
	
# Note: In Zsh, aliases are listed directly with 'alias' command (without -p flag like in Bash)

Examples:
--------
	adal cdsvn 'cd ~/dev/svn/' 		-- Safely Adds the alias 'cdsvn' without overwriting and existing one and persist the changes.
	chal e3 '~/dev/eclipse3.6/eclipse'	-- Safely change the existing alias 'e3' to some other value and persist the changes.
	rmal e3 		 		-- Removes the alias 'e3' and persist the changes.
	cpal algrep ag 		 		-- Copies the 'algrep' alias to the new alias 'ag' and persist the changes.
	mval sdiff sdf 		 		-- Renames the 'sdiff' alias to the new alias 'sdf' and persist the changes.
	
	
	adfn dex 'docker exec -it \$1 /bin/bash'		-- Safely adds a functions as alias that will accept an argument, and persists it.
	chfn dlf 'docker logs -f \$1 logger-sidecar'	-- Safely changes the function definition in the alias that will accept an argument, and persists it.
	rmfn dlf					--  Removes the alias function and persists the changes.
	cpfn dockerrun drn				-- Copies the alias function 'dockerrun' to the new alias 'drn' and persist the changes.
	mvfn dockerpull dpll				-- Renames the 'dockerpull' alias function to the new alias 'dpll' and persist the changes.
EOF
}

qsa_install() {
	# Define basic aliases
	alias al=alias
	alias unal=unalias
	alias lsal='alias'
	alias algrep='alias | grep'
	
	# Function-related aliases
	alias lsfn='aleval lsal | grep $ALIAS_FUNC_PREFIX'
	alias fngrep='alias | grep $ALIAS_FUNC_PREFIX | grep'
	
	# Source existing aliases if available
	[ -e $ZSH_ALIAS_FILE_PATH ] && source $ZSH_ALIAS_FILE_PATH
	
	# Copy the special aliases helper script to home directory if it exists in the same location
	helper_path="$(dirname "$0")/zsh_special_aliases.sh"
	if [ -f "$helper_path" ]; then
		cp "$helper_path" ~/.zsh_special_aliases.sh
		chmod +x ~/.zsh_special_aliases.sh
	elif [ -f "/Users/loganathan.sekaran/Library/CloudStorage/OneDrive-5SecCyberpwnTechnologiesPvt.Ltd/git/QuickSaveAlias/zsh_special_aliases.sh" ]; then
		cp "/Users/loganathan.sekaran/Library/CloudStorage/OneDrive-5SecCyberpwnTechnologiesPvt.Ltd/git/QuickSaveAlias/zsh_special_aliases.sh" ~/.zsh_special_aliases.sh
		chmod +x ~/.zsh_special_aliases.sh
	else
		# Create the helper script if it doesn't exist
		cat > ~/.zsh_special_aliases.sh << 'EOL'
#!/bin/zsh
# Helper script for QuickSaveAlias to manage special character aliases in Zsh
# This file is automatically updated by the QuickSaveAlias system when you use sval

# Common default special character aliases for Zsh users
# These will be kept even if not in your current configuration

# Special character aliases begin
alias -='cd -'
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias _='sudo '
# Special character aliases end

# Load the rest of the aliases from the main file
if [ -f ~/.zsh-aliases ]; then
  source ~/.zsh-aliases
fi
EOL
		chmod +x ~/.zsh_special_aliases.sh
	fi
	
	# Ensure aliases will be loaded at startup using the special helper
	if grep -q "source ~/.zsh-aliases" ~/.zshrc; then
		# Replace direct sourcing with our helper script
		sed -i '' '/source ~\/.zsh-aliases/d' ~/.zshrc
	fi
	
	if ! grep -q "source ~/.zsh_special_aliases.sh" ~/.zshrc; then
		echo -e "\n# Load all aliases including special character aliases" >> ~/.zshrc
		echo "[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh" >> ~/.zshrc
		echo "Added special alias loading helper to ~/.zshrc"
	fi
	
	# Save all aliases and sync special character aliases
	sval
	
	echo "QuickSaveAlias (macOS/Zsh) installation complete."
}

## Check if the alias exists
qsa_check_alias_exist() {
	alias_name=$1
	
	alias_declaration=$(alias | grep " $alias_name=")

	if [[ "x$alias_declaration" = "x" ]]; then
		echo "FALSE"
	else
		echo "TRUE"
	fi
}

## Add the alias and persist the changes.
adal() {
	if [ $# -lt 2 ]; then
		echo -e "adal: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	alias_name=$1
	alias_val=$2

	if [[ $(qsa_check_alias_exist $1) = "TRUE" ]]; then
		 echo "Alias $alias_name already exists! Use 'chal' instead." 
	else
		# Check if this is a special character alias that needs quoting
		if [[ $(isSpecialCharAlias "$alias_name") = "TRUE" ]]; then
			# Need to use single quotes for the entire alias command for special character aliases
			eval "alias '$alias_name=$alias_val'"
			# For special character aliases, also add to helper script directly
			syncSpecialAliases
		else
			# Regular alias
			alias $alias_name="$alias_val"
			sval
		fi
	fi
}

## Remove the alias and persist the changes.
rmal() {
	if [ $# -lt 1 ]; then
		echo -e "rmal: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	alias_name=$1

	if [[ $(qsa_check_alias_exist $1) = "TRUE" ]]; then
		unalias $alias_name
		# Check if this was a special character alias
		if [[ $(isSpecialCharAlias "$alias_name") = "TRUE" ]]; then
			syncSpecialAliases
		else
			sval
		fi
	else 
		echo "Alias $alias_name does not exist!"
	fi
}

## Change the alias and persist the changes.
chal() {
	if [ $# -lt 2 ]; then
		echo -e "chal: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	alias_name=$1
	alias_val=$2
	if [[ $(qsa_check_alias_exist $1) = "TRUE" ]]; then
		# Check if this is a special character alias that needs quoting
		if [[ $(isSpecialCharAlias "$alias_name") = "TRUE" ]]; then
			# Need to use single quotes for the entire alias command for special character aliases
			eval "alias '$alias_name=$alias_val'"
			# For special character aliases, also update helper script directly
			syncSpecialAliases
		else
			# Regular alias
			alias $alias_name="$alias_val"
			sval
		fi 
	else
		echo "Alias $alias_name does not exist!"
	fi
}

## Copy the alias to a different name and persist the changes.
cpal() {
	if [ $# -lt 2 ]; then
		echo -e "cpal: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	alias_name=$1
	new_alias_name=$2
	if [[ $(qsa_check_alias_exist $1) = "TRUE" ]]; then
		if [[ $(qsa_check_alias_exist $2) = "TRUE" ]]; then
 			echo "Alias $new_alias_name already exists!"
			return 1
		else
			#Getting the old alias value
			alias_declaration=$(alias | grep " $alias_name=")
			alias_val=$(echo ${alias_declaration##*=})
			#Strip surrounding single quotes
			alias_val=$(stripSurroundingSingleQuotes "$alias_val")
			
			#Creating the new alias
			if [[ $(isSpecialCharAlias "$new_alias_name") = "TRUE" ]]; then
				# Use eval for special character aliases
				eval "alias '$new_alias_name=$alias_val'"
				syncSpecialAliases
			else
				alias $new_alias_name="$alias_val"
				sval
			fi
		fi
	else
		echo "Alias $alias_name does not exist!"
		return 1
	fi
}

## Move the alias to a different name and persist the changes.
mval() {
	if [ $# -lt 2 ]; then
		echo -e "mval: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	alias_name=$1
	new_alias_name=$2
	
	if [[ ! $(qsa_check_alias_exist $1) = "TRUE" ]]; then
		echo "Alias $alias_name does not exist!"
		return 1
	fi
	
	if [[ $(qsa_check_alias_exist $2) = "TRUE" ]]; then
		echo "Alias $new_alias_name already exists!"
		return 1
	fi
	
	# Get the old alias value
	alias_declaration=$(alias | grep " $alias_name=")
	alias_val=$(echo ${alias_declaration##*=})
	# Strip surrounding single quotes
	alias_val=$(stripSurroundingSingleQuotes "$alias_val")
	
	# Create the new alias
	if [[ $(isSpecialCharAlias "$new_alias_name") = "TRUE" ]]; then
		# Use eval for special character aliases
		eval "alias '$new_alias_name=$alias_val'"
	else
		alias $new_alias_name="$alias_val"
	fi
	
	# Remove the old alias
	unalias $alias_name
	
	# Save changes and sync special aliases
	sval
	
	# Special handling if either was a special character alias
	if [[ $(isSpecialCharAlias "$alias_name") = "TRUE" ]] || [[ $(isSpecialCharAlias "$new_alias_name") = "TRUE" ]]; then
		syncSpecialAliases
	fi
}

adfn() {
    # Zsh-compatible function definition
    funcdef=$(printf "${ALIAS_FUNC_PREFIX}$1() { $2 ; }; ${ALIAS_FUNC_PREFIX}$1")
	adal $1 "${funcdef}"
}

chfn() {
    # Zsh-compatible function definition
    funcdef=$(printf "${ALIAS_FUNC_PREFIX}$1() { $2 ; }; ${ALIAS_FUNC_PREFIX}$1")
	chal $1 "${funcdef}"
}

rmfn() {
	rmal $1
}

cpfn() {
	cpal $1 $2
}

mvfn() {
	mval $1 $2
}

alval() {
	if [ $# -lt 1 ]; then
		echo -e "alval: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
	
	alias_name=$1
	alias_line=$(alias | grep "$1"=)
	if [[ $alias_line = "" ]]; then
		echo "Alias $alias_name does not exist!"
		return 1
	else
		alias_val=$(splitByFirstOccrOfEqualAndGetVal "$alias_line")
		alias_val=$(stripSurroundingSingleQuotes "$alias_val")
		echo $alias_val
	fi
}

aleval() {
	if [ $# -lt 1 ]; then
		echo -e "aleval: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
	
	alias_val=$(alval $1)
	eval "$alias_val"
}

stripSurroundingSingleQuotes() {
    if [ $# -lt 1 ]; then
		echo -e "stripSurroundingSingleQuotes: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi

	# More robust for Zsh quote handling
	echo $1 | sed -E "s/^[\"'](.*)[\"\']$/\1/g"
}

# Helper function to check if an alias name has special characters that need quoting
needsQuoting() {
    if [ $# -lt 1 ]; then
		echo -e "needsQuoting: Insufficient arguments!\n"
		return 1
	fi
	
	local name=$1
	# Expanded pattern matching to catch more special characters that can cause issues in Zsh
	if [[ "$name" == -* || "$name" == .* || "$name" == [0-9]* || 
	      "$name" == *-* || "$name" == *+* || "$name" == *\** || 
	      "$name" == *\!* || "$name" == *\&* || "$name" == *=* ||
          "$name" == *\?* || "$name" == *\#* || "$name" == *\$* ||
          "$name" == *\%* || "$name" == *\^* || "$name" == *\~* ||
          "$name" == *\@* || "$name" == *\/* || "$name" == *\\* ]]; then
		echo "TRUE"
	else
		echo "FALSE"
	fi
}

splitByFirstOccrOfEqualAndGetVal() {
	if [ $# -lt 1 ]; then
		echo -e "splitByFirstOccrGetVal: Insufficient arguments!\n"
		qsa_show_help
		return 1
	fi
		
	echo $( cut -d '=' -f 2- <<< "$1" )
}

## Main ##
qsa_main() {
	qsa_declare_constants
	
	#If there is no argument, just print the usage
	if [ $# -lt 1 ] || [ $1 = '-h' ] || [ $1 = '--help' ]; then
		qsa_show_help
		return 1
	fi

	if [ $1 = '-install' ]; then
		qsa_install
	fi
}

# Function to check if an alias should be put in the special aliases helper
isSpecialCharAlias() {
    local alias_name=$1
    if [[ $(needsQuoting "$alias_name") = "TRUE" ]]; then
        echo "TRUE"
    else
        echo "FALSE"
    fi
}

# Function to synchronize special character aliases to the helper script
syncSpecialAliases() {
    local helper_script=~/.zsh_special_aliases.sh
    
    # If helper script doesn't exist, create it with a basic structure
    if [[ ! -f "$helper_script" ]]; then
        cat > "$helper_script" << 'EOL'
#!/bin/zsh
# Helper script for QuickSaveAlias to manage special character aliases in Zsh

# These are the special character aliases that can cause issues when loaded from a file
# Do not edit this section manually - it is managed by QuickSaveAlias

# Special character aliases begin
# Special character aliases end

# Load the rest of the aliases from the main file
if [ -f ~/.zsh-aliases ]; then
  source ~/.zsh-aliases
fi
EOL
        chmod +x "$helper_script"
    fi

    # Get current list of aliases
    local all_aliases=$(alias)
    local special_aliases=""
    
    # Parse through each alias and identify special character ones
    while IFS= read -r line; do
        if [[ "$line" == alias* ]]; then
            # Extract alias name (between 'alias ' and '=')
            local alias_name=$(echo "$line" | sed -E 's/alias ([^=]+)=.*/\1/')
            
            # Check if this is a special character alias
            if [[ $(isSpecialCharAlias "$alias_name") = "TRUE" ]]; then
                # Extract the alias definition (everything after the first =)
                local alias_def=$(echo "$line" | sed -E 's/alias [^=]+=(.+)/\1/')
                special_aliases+="alias $alias_name=$alias_def\n"
            fi
        fi
    done <<< "$all_aliases"
    
    # Update the helper script with the special aliases
    local temp_file=$(mktemp)
    local in_special_section=0
    
    # Read the helper script and replace the special aliases section
    while IFS= read -r line; do
        if [[ "$line" == "# Special character aliases begin" ]]; then
            echo "$line" >> "$temp_file"
            echo "$special_aliases" >> "$temp_file"
            in_special_section=1
        elif [[ "$line" == "# Special character aliases end" ]]; then
            echo "$line" >> "$temp_file"
            in_special_section=0
        elif [[ $in_special_section -eq 0 ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$helper_script"
    
    # Replace the helper script with the updated content
    mv "$temp_file" "$helper_script"
    chmod +x "$helper_script"
    
    echo "Special character aliases synchronized to $helper_script"
}

##Invoke Main##
qsa_main $*
