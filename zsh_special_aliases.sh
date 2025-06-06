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
