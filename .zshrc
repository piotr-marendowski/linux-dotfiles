## PROMPT
# Load colors
autoload -U colors && colors

# Display git branch
# Enable colors and change prompt
autoload -U colors && colors
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' [%b]'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%B%{$fg[blue]%}%n%{$fg[yellow]%}${vcs_info_msg_0_} %{$fg[magenta]%}%~%b '


## ENV VARS
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
export PATH="/home/$(whoami)/.local/bin:/usr/local/bin:/usr/bin:/home/$(whoami)/.local/share/gem/ruby/3.0.0/bin:$PATH"
export VISUAL=nvim
export EDITOR=nvim


## ALIASES
alias ll="ls -la --color=auto"
alias -- -="cd -"
alias ..="cd .."
function joinstr { local IFS="$1"; shift; echo "$*"; }
function fcd { cd $(joinstr \* $(echo "$*" | fold -w1))* }
# fff file manager:
export FFF_HIDDEN=1
export FFF_COL1=4
export FFF_COL2=9
export FFF_COL5=6
export FFF_COL4=9
export FFF_FILE_ICON=1
export FFF_GIT_CHANGES=1
export FFF_FILE_DETAILS=0
# bookmarks
export FFF_FAV1=~/Documents
export FFF_FAV2=~/.config
export FFF_FAV3=~/Downloads
# cd on exit => run `f` and quit with `q`
f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}


# HISTORY IN CACHE
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=${XDG_CACHE_HOME:-"$HOME/.cache"}/.zsh_history
setopt appendhistory


## BASIC AUTO/TAB COMPLETE
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.


## VI MODE
bindkey -v
export KEYTIMEOUT=1

# Use vi keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


## KEYBINDINGS
# file manager on ctrl-o
bindkey -s '^o' 'f\n'

# fzf on ctrl-c
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

# Edit line in neovim with ctrl-n:
autoload edit-command-line; zle -N edit-command-line
bindkey '^n' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^n' edit-command-line
bindkey -M visual '^[[P' vi-delete


## LAST WORKING DIRECTORY 
# Flag indicating if we've previously jumped to last directory
typeset -g ZSH_LAST_WORKING_DIRECTORY

# Updates the last directory once directory is changed
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_last_working_dir
chpwd_last_working_dir() {
    # Don't run in subshells
    [[ "$ZSH_SUBSHELL" -eq 0 ]] || return 0
    # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
    local cache_file="${XDG_CACHE_HOME:-"$HOME/.cache"}/zsh-last-working-dir"
    builtin pwd >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
    # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
    local cache_file="${XDG_CACHE_HOME:-"$HOME/.cache"}/zsh-last-working-dir"
    [[ -r "$cache_file" ]] && cd "$(cat "$cache_file")"
}

# Jump to last directory automatically unless:
# - this isn't the first time the plugin is loaded
# - it's not in $HOME directory
[[ -n "$ZSH_LAST_WORKING_DIRECTORY" ]] && return
[[ "$PWD" != "$HOME" ]] && return

lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true


# Load autosuggestions and syntax highlighting; should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

