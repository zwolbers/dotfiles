# If not running interactively, don't do anything
[ -z "$PS1" ] && return

shopt -s histappend

HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignorespace:ignoredups:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

function prompt_command() {
    local -r exit="$?"
    PS1=""

    # show exit code on failure
    [[ ${exit} -ne 0 ]] && PS1+="\[\e[1;31m\]${exit}\[\e[m\]\n"

    [[ -n ${SSH_CLIENT} ]] && PS1+="\[\e[2m\]"  # 'dim' if ssh'd
    PS1+="\[\e[1;32m\]\u@\h\[\e[m\]"            # user@host
    PS1+=":"                                    # :
    PS1+="\[\e[1;34m\]\w\[\e[m\]"               # path
    PS1+="\\$ "                                 # $ for user, # for root
}
PROMPT_COMMAND="prompt_command"

function cleanup() {
    # Figet with the history so that duplicates are properly removed
    history -n  # Read lines not already read from ~/.bash_history
    history -w  # Overwrite ~/.bash_history with current history list
    history -c  # Clear history list
    history -r  # Append contents of ~/.bash_history to history list
}
trap cleanup exit

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable fzf magic.  Note that even though 'vi' mode was already enabled
# in ~/.inputrc, it must be set again for fzf to properly detect it.
set -o vi
[ -f /usr/share/fzf/key-bindings.bash ] && . /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && . /usr/share/fzf/completion.bash

# Enable tmuxinator bash completion, if installed
tmuxinator_bash_path=$(find ~/.gem -name tmuxinator.bash | sort | tail -n 1 2>/dev/null)
if [[ ! -z $tmuxinator_bash_path ]]; then
    . $tmuxinator_bash_path
fi

alias cat='bat'
alias diff='diff --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lah'

alias grep='grep --color=auto --exclude-dir=.svn'
alias fgrep='fgrep --color=auto --exclude-dir=.svn'
alias egrep='egrep --color=auto --exclude-dir=.svn'

alias sudo='sudo '
alias nless='/usr/share/nvim/runtime/macros/less.sh'
alias hist='history | sort -uk 2 | sort -n | grep'
alias preview="fzf --preview 'bat --color \"always\" {}'"

