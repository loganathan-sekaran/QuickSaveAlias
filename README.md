Quick Save Alias - Version 1.1.0
==================================
Used to quickly add, remove, change aliases and alias functions which will be persisted for future use automatically.

Note: This feature will be applied only for the particular user where it is installed.

# Alias Functions
Alias functions are functions with single line statements that can accept function arguments, stored as alias.

Installing:
-----------

To install the script for the session, copy the following code to ~/.bashrc or ~/.bash-profile :

````
# Install QuickSaveAlias for the session
[ -e ~/quicksavealias.sh ] && source ~/quicksavealias.sh -install
````

Hint: You can copy the file to home directory and make the file hidden by prefixing by period and then install as below

````
# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
````


Un-installing:
-------------
Just remove the entry added for installing the feature in ~/.bashrc or ~/.bash-profile .

Note: 
* To reuse the aliases created, across multiple installations, multiple users and multiple linux machines, 
have a backup of the file ~/.bash-aliases and copy it to the home directory before installing the script as above. 
* To remove all the new aliases created just delete ~/.bash-aliases file.

Usage:
======

Utility functions:
------------------
````
  adal    <alias name> <alias value>              : To add an alias and persist the change.
  rmal    <alias name> <alias value>              : To remove an alias and persist the change.
  chal    <alias name> <alias value>              : To change an alias and persist the change.
  cpal    <old alias name> <new alias name>       : Copy an old alias to a new alias name and persist the change.
  mval    <old alias name> <new alias name>       : Rename an old alias with a new name and persist the change.

  adfn    <function name> <function value>                : To add an alias function and persist the change. This function can have arguments like $1, $2.
  rmfn    <function name> <function value>                : To remove an alias function and persist the change. This function can have arguments like $1, $2.
  chfn    <function name> <function value>                : To change an alias function and persist the change. This function can have arguments like $1, $2.
  cpfn    <old function name> <new function name>         : Copy an old alias function to a new alias function name and persist the change. This function can have arguments like $1, $2.
  mvfn    <old function name> <new function name>         : Rename an old alias function with a new name and persist the change. This function can have arguments like $1, $2.

  alh     : To show this usage.
````

Aliases:
--------
````
  al                                      : Shortcut for 'alias'
  unal                                    : Shortcut for 'unalias'
  lsal                                    : Shorcut for 'alias -p' - used to list the aliases
  sval                                    : Saves all the aliases to '$BASH_ALIAS_FILE_PATH' for future usage.
  algrep [grep_options] GREP_PATTERN      : used to find the alias based on the grep pattern.

  lsfn                                    : list all alias functions
  fngrep [grep_options] GREP_PATTERN      : used to find the alias functions based on the grep pattern.
````

Examples:
--------
````
  adal cdsvn 'cd ~/dev/svn/'          --  Safely Adds the alias 'cdsvn' without overwriting 
                                          and existing one and persist the changes.
  chal e3 '~/dev/eclipse3.6/eclipse'  --  Safely change the existing alias 'e3' to some other value 
                                          and persist the changes.
  rmal e3                             --  Removes the alias 'e3' 
                                          and persist the changes.
  cpal algrep ag                      --  Copies the 'algrep' alias to the new alias 'ag' 
                                          and persist the changes.
  mval sdiff sdf                      --  Renames the 'sdiff' alias to the new alias 'sdf' 
                                          and persist the changes.

  adfn dex 'docker exec -it  /bin/bash'           -- Safely adds a functions as alias that will accept an argument, and persists it.
  chfn dlf 'docker logs -f  logger-sidecar'       -- Safely changes the function definition in the alias that will accept an argument, and persists it.
  rmfn dlf                                        --  Removes the alias function and persists the changes.
  cpfn dockerrun drn                              -- Copies the alias function 'dockerrun' to the new alias 'drn' and persist the changes.
  mvfn dockerpull dpll                            -- Renames the 'dockerpull' alias function to the new alias 'dpll' and persist the changes.
````
