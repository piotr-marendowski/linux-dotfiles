# Enable colors and change prompt:
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
user_name=$(whoami)
export PATH="/home/$user_name/.local/bin:/usr/local/bin:/usr/bin:/home/$(whoami)/.local/share/gem/ruby/3.0.0/bin:$PATH"
export VISUAL=nvim
export EDITOR=nvim
# nnn bookmarks
# A string of key_char:location pairs separated by semicolons (;):
#
# The bookmarks are listed in the help and config screen (key ?).
# The select bookmark key b lists all the bookmark keys set in NNN_BMS in the bookmarks prompt.
export NNN_BMS="d:$HOME/Documents;D:$HOME/Downloads"

## ALIASES
alias ll="ls -la --color=auto"
alias nnn="nnn -deH"

# History in cache directory:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
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
# nnn file manager on ctrl-o
bindkey -s '^o' 'nnn -deH\n'

# fzf on ctrl-c
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in neovim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# Load autosuggestions and syntax highlighting; should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

