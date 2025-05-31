Quick Save Alias - Version 1.1.0
==================================
Used to quickly add, remove, change **aliases** and **alias functions** which will be persisted for future use automatically.

Note: This feature will be applied only for the particular user where it is installed.

# Alias Functions
Alias functions are functions with single line statements that can accept function arguments, stored as alias.
For example,

````
dex='docker exec -it $1 /bin/bash'
````

This can be invoked as below:
````
dex my-docker-container:latest
````

Installatioin:
-----------

To install the script for the session, 
* Download the file [quicksavealias.sh](https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias.sh) file to your home folder.
* Copy the following code to ~/.bashrc or ~/.bash-profile.

````
# Install QuickSaveAlias for the session
[ -e ~/quicksavealias.sh ] && source ~/quicksavealias.sh -install
````

Hint: You can copy the file to home directory and make the file hidden by prefixing by period and then install as below
Note: This can be placed elsewhere also if required. Please alter the above installation command appropriately.

````
# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
````

* And then source that file (~/.bashrc or ~/.bash-profile) or re-login to use QuickSaveAlias.

Quick-Installation:
-------------------
* To quickly install QuickSaveAlias:
````
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install.sh | bash && source ~/.bashrc
````

* To quickly install QuickSaveAlias with basic aliases backup (my_aliases_backup/.bash-aliases):
````
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install.sh | bash -s basic && source ~/.bashrc
````

* To quickly install QuickSaveAlias with some other aliases backup (my_aliases_backup/.bash-aliases-&lt;some-other-backup&gt;):
````
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install.sh | bash -s <some-other-backup> && source ~/.bashrc
````
For Example:

````
curl -s https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install.sh | bash -s dev && source ~/.bashrc
````


Un-installation:
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

  adfn dex 'docker exec -it $1 /bin/bash'           -- Safely adds a functions as alias that will accept an argument, and persists it.
  chfn dlf 'docker logs -f $1 logger-sidecar'       -- Safely changes the function definition in the alias that will accept an argument, and persists it.
  rmfn dlf                                        --  Removes the alias function and persists the changes.
  cpfn dockerrun drn                              -- Copies the alias function 'dockerrun' to the new alias 'drn' and persist the changes.
  mvfn dockerpull dpll                            -- Renames the 'dockerpull' alias function to the new alias 'dpll' and persist the changes.
````

Zsh Installation (macOS):
------------------------
* Download the file [quicksavealias_mac.sh](https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias_mac.sh) to your home folder as `.quicksavealias.sh`.
* Download the helper file [zsh_special_aliases.sh](https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/zsh_special_aliases.sh) to your home folder as `.zsh_special_aliases.sh`.
* Add the following to your ~/.zshrc:

```zsh
# Install QuickSaveAlias for the session (Zsh)
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
```

* Then run: `source ~/.zshrc` or restart your terminal.

**Special Character Aliases in Zsh**

Zsh handles special characters in alias names differently than Bash. Aliases with special characters like `-`, `.`, or starting with numbers can cause parsing errors when loaded from a file. QuickSaveAlias uses a two-part approach to handle this:

1. Regular aliases are saved to `~/.zsh-aliases`
2. Special character aliases (like `-=cd -`, `...=../..`, etc.) are managed through `~/.zsh_special_aliases.sh`

When you use `adal`, `chal`, etc. with special character aliases, they're automatically detected and handled appropriately. Common special character aliases are included by default:

```zsh
alias -='cd -'        # Go to previous directory
alias ...='../..'     # Go up two directories
alias ....='../../..' # Go up three directories
alias 1='cd -1'       # Go to the 1st directory in the directory stack
```

If you see any issues with aliases containing special characters:

1. Run `fixal` to fix the format of your alias file
2. Use the `syncSpecialAliases` function to synchronize your special character aliases
