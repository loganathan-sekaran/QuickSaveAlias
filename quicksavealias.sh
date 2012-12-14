#!/usr/bin/env bash
#
# Quick Save Alias
#
# Author:Loganathan.S
#

## Global Declarations
#

#constants
QSA_SCRIPT_VERSION='1.0.0'

#Aliases
alias sval='alias -p > $BASH_ALIAS_FILE_PATH'

## Declare other constants
__declare_constants() {
  BASH_ALIAS_FILE_PATH=~/.bash-aliases
}



__show_help() {

	#Info about Quick Save Alias
	__about_qsa
	#Installation Guide
	__installation_guide
	#Usage Guide
	__usage_guide

}

__about_qsa() {

cat << EOF

Quick Save Alias - Version $QSA_SCRIPT_VERSION
==================================
Used to quickly add, remove, change aliases which will be persisted for future use automatically.

Note: This feature will be applied only for the particular user where it is installed.

EOF

}

__installation_guide() {

cat << EOF

Installing:
-----------

To install the script for the session, copy the following code to ~/.bashrc or ~/.bash-profile :

# Install QuickSaveAlias for the session
[ -e ~/quicksavealias.sh ] && source quicksavealias.sh -install

Hint: You can copy the file to home directory and make the file hidden by prefixing by period and then install as below

# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source .quicksavealias.sh -install


Un-installing:
-------------
Just remove the entry added for installing the feature in ~/.bashrc or ~/.bash-profile .

Note: 
* To reuse the aliases created, across multiple installations, multiple users and multiple linux machines, 
have a backup of the file ~/.bash-aliases and copy it to the home directory before installing the script as above. 
* To remove all the new aliases created just delete ~/.bash-aliases file

EOF

}

alh() {

	#Info about Quick Save Alias
	__about_qsa
	#Usage Guide
	__usage_guide

}

__usage_guide() {

cat << EOF

Usage:
======

Utility functions:
------------------
	adal 	<alias name> <alias value>	: To add an alias and persist the change.
	rmal	<alias name> <alias value>	: To remove an alias and persist the change.
	chal	<alias name> <alias value>	: To change an alias and persist the change.

	alh	: To show this usage.


Aliases:
--------
	al 	: Shortcut for 'alias'
	unal 	: Shortcut for 'unalias'
	lsal 	: Shorcut for 'alias -p' - used to list the aliases
	sval 	: Saves all the aliases to '$BASH_ALIAS_FILE_PATH' for future usage.

Examples:
--------
	adal cdsvn 'cd ~/dev/svn/' 		-- Safely Adds the alias 'cdsvn' without overwriting and existing one and persist the changes.
	chal e3 '~/dev/eclipse3.6/eclipse'	-- Safely change the existing alias 'e3' to some other value and persist the changes.
	rmal e3 		 		-- Removes the alias 'e3' and persist the changes.

EOF

}

__install() {

	#declare the aliases
	alias al=alias
	alias unal=unalias
	alias lsal='alias -p'

	#Source the existing aliases if available
	[ -e $BASH_ALIAS_FILE_PATH ] && source $BASH_ALIAS_FILE_PATH

	#Save the aliases
	sval	

}

## Check if the alias existse
__check_alias_exist() {
	alias_name=$1
	
	alias_declaration=`alias -p | grep " $alias_name="`


	if [[ "x$alias_declaration" = "x" ]];
	then
		echo "FALSE"
	else
		echo "TRUE"
	fi
}

## Add the alias and persist the changes.
adal() {

	if [ $# -lt 2 ];
	then
		echo -e "adal: Insufficient arguments!\n"
		__show_help
		return 1;
	fi
		
	alias_name=$1
	alias_val=$2

	if [[ `__check_alias_exist $1` = "TRUE" ]];
	then
		 echo "Alias $alias_name already exists! Use 'chal' instead." 
	else 	
		alias $alias_name="$alias_val"
		sval
	fi
}

## Remove the alias and persist the changes.
rmal() {

	if [ $# -lt 1 ];
	then
		echo -e "rmal: Insufficient arguments!\n"
		__show_help
		return 1;
	fi
		

	alias_name=$1

	if [[ `__check_alias_exist $1` = "TRUE" ]];
	then
		unalias $alias_name
		sval 
	else 
		echo "Alias $alias_name does not exist!"
	fi

}

## Change the alias and persist the changes.
chal() {

	if [ $# -lt 2 ];
	then
		echo -e "rmal: Insufficient arguments!\n"
		__show_help
		return 1;
	fi
		

	alias_name=$1
	alias_val=$2
	if [[ `__check_alias_exist $1` = "TRUE" ]];
	then
		alias $alias_name="$alias_val"
		sval 
	else
		echo "Alias $alias_name does not exist!"
	fi

}

## Main ##
main() {

	__declare_constants
	
	#If there is no argument, just print the usage
	if [ $# -lt 1 ] || [ $1 == '-h' ] || [ $1 == '--help' ];
	then
		__show_help
		return $FALSE;
	fi

	if [ $1 == '-install' ];
	then
		__install
	fi
}

##Invoke Main##
main $*
