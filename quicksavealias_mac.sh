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
alias sval='alias > $ZSH_ALIAS_FILE_PATH'

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
	#declare the aliases
	alias al=alias
	alias unal=unalias
	alias lsal='alias'
	alias algrep='alias | grep'
	
	# In Zsh, we use 'alval' with 'lsal' to handle alias functions
	alias lsfn='aleval lsal | grep $ALIAS_FUNC_PREFIX'
	alias fngrep='alias | grep $ALIAS_FUNC_PREFIX | grep'

	#Source the existing aliases if available
	[ -e $ZSH_ALIAS_FILE_PATH ] && source $ZSH_ALIAS_FILE_PATH
	
	#Save the aliases
	sval
	
	# Ensure aliases will be loaded at startup
	if ! grep -q "source ~/.zsh-aliases" ~/.zshrc; then
		echo -e "\n# Load saved aliases" >> ~/.zshrc
		echo "[ -f ~/.zsh-aliases ] && source ~/.zsh-aliases" >> ~/.zshrc
		echo "Added automatic loading of aliases to ~/.zshrc"
	fi
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
		alias $alias_name="$alias_val"
		sval
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
		sval 
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
		alias $alias_name="$alias_val"
		sval 
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
			alias $new_alias_name="$alias_val"
			#Save changes
			sval
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
	#Copy the old alias to a new alias name
	cpal $1 $2
	if [ ! $? -eq 1 ]; then
		#Removing the old alias
		unalias $alias_name
		#Save changes after removing old alias
		sval
	else
		return 1
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

##Invoke Main##
qsa_main $*
