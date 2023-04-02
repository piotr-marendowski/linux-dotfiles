#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

user_name=whoami

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
export PATH="/home/$user_name/.local/bin:$PATH"

PS1='[\u@\h \W]\$ '
