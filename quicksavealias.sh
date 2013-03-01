#!/usr/bin/env bash
#
# Quick Save Alias
#
# Author:Loganathan.S
#

## Global Declarations
#

#constants
QSA_SCRIPT_VERSION='1.0.2'

#Aliases
alias sval='alias -p > $BASH_ALIAS_FILE_PATH'

## Declare other constants
qsa_declare_constants() {
	BASH_ALIAS_FILE_PATH=~/.bash-aliases
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

Quick Save Alias - Version $QSA_SCRIPT_VERSION
==================================
Used to quickly add, remove, change aliases which will be persisted for future use automatically.

Note: This feature will be applied only for the particular user where it is installed.

EOF

}

qsa_installation_guide() {

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
	adal 	<alias name> <alias value>		: To add an alias and persist the change.
	rmal	<alias name> <alias value>		: To remove an alias and persist the change.
	chal	<alias name> <alias value>		: To change an alias and persist the change.
	cpal	<old alias name> <new alias name>	: Copy an old alias to a new alias name and persist the change.
	mval	<old alias name> <new alias name>	: Rename an old alias with a new name and persist the change.

	alh	: To show this usage.


Aliases:
--------
	al                                      : Shortcut for 'alias'
	unal                                    : Shortcut for 'unalias'
	lsal                                    : Shorcut for 'alias -p' - used to list the aliases
	sval                                    : Saves all the aliases to '$BASH_ALIAS_FILE_PATH' for future usage.
	algrep [grep_options] GREP_PATTERN      : used to find the alias based on the grep pattern.

Examples:
--------
	adal cdsvn 'cd ~/dev/svn/' 		-- Safely Adds the alias 'cdsvn' without overwriting and existing one and persist the changes.
	chal e3 '~/dev/eclipse3.6/eclipse'	-- Safely change the existing alias 'e3' to some other value and persist the changes.
	rmal e3 		 		-- Removes the alias 'e3' and persist the changes.

EOF

}

qsa_install() {

	#declare the aliases
	alias al=alias
	alias unal=unalias
	alias lsal='alias -p'
	alias algrep='alias -p | grep'

	#Source the existing aliases if available
	[ -e $BASH_ALIAS_FILE_PATH ] && source $BASH_ALIAS_FILE_PATH

	#Save the aliases
	sval	

}

## Check if the alias existse
qsa_check_alias_exist() {
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
		qsa_show_help
		return 1;
	fi
		
	alias_name=$1
	alias_val=$2

	if [[ `qsa_check_alias_exist $1` = "TRUE" ]];
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
		qsa_show_help
		return 1;
	fi
		

	alias_name=$1

	if [[ `qsa_check_alias_exist $1` = "TRUE" ]];
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
		qsa_show_help
		return 1;
	fi
		

	alias_name=$1
	alias_val=$2
	if [[ `qsa_check_alias_exist $1` = "TRUE" ]];
	then
		alias $alias_name="$alias_val"
		sval 
	else
		echo "Alias $alias_name does not exist!"
	fi

}

## Copy the alias to a different name and persist the changes.
cpal() {

	if [ $# -lt 2 ];
	then
		echo -e "mval: Insufficient arguments!\n"
		qsa_show_help
		return 1;
	fi
		

	alias_name=$1
	new_alias_name=$2
	if [[ `qsa_check_alias_exist $1` = "TRUE" ]];
	then
		if [[ `qsa_check_alias_exist $2` = "TRUE" ]];
		then
 			echo "Alias $new_alias_name already exists!"
			return 1;
		else
			#Getting the old alias value
			alias_declaration=`alias -p | grep " $alias_name="`
			alias_val=`echo ${alias_declaration##*=}`
			#Strip surrounding single quotes
			alias_val=`echo $alias_val | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g"`
			#Creating the new alias
			alias $new_alias_name="$alias_val"
			#Save changes
			sval

		fi
	else
		echo "Alias $alias_name does not exist!"
		return 1;
	fi

}

## Move the alias to a different name and persist the changes.
mval() {

	if [ $# -lt 2 ];
	then
		echo -e "cpal: Insufficient arguments!\n"
		qsa_show_help
		return 1;
	fi
		

	alias_name=$1
	new_alias_name=$2
	#Copy the old alias to a new alias name
	cpal $1 $2
	if [ ! $? -eq 1 ];
	then
			#Removing the old alias
			unalias $alias_name
	else
		return 1;
	fi

}

## Main ##
qsa_main() {

	qsa_declare_constants
	
	#If there is no argument, just print the usage
	if [ $# -lt 1 ] || [ $1 == '-h' ] || [ $1 == '--help' ];
	then
		qsa_show_help
		return 1;
	fi

	if [ $1 == '-install' ];
	then
		qsa_install
	fi
}

##Invoke Main##
qsa_main $*
