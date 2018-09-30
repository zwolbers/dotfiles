# If not running interactively, don't do anything
[ -z "$PS1" ] && return

shopt -s histappend

HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:ignorespace

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

    PS1+="\[\e[1;35m\]\!\[\e[m\] "              # history numbers
    [[ -n ${SSH_CLIENT} ]] && PS1+="\[\e[4m\]"  # underline if ssh'd
    PS1+="\[\e[1;32m\]\u@\h\[\e[m\]"            # user@host
    PS1+=":"                                    # :
    PS1+="\[\e[1;34m\]\w\[\e[m\]"               # path
    PS1+="\\$ "                                 # $ for user, # for root
}
PROMPT_COMMAND=prompt_command

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Enable tmuxinator bash completion, if installed
tmuxinator_bash_path=$(find ~/.gem -name tmuxinator.bash 2>/dev/null)
if [[ ! -z $tmuxinator_bash_path ]]; then
    . $tmuxinator_bash_path
fi

alias cat='bat'
alias ls='ls --color=auto'
alias ll='ls -lah'

alias grep='grep --color=auto --exclude-dir=.svn'
alias fgrep='fgrep --color=auto --exclude-dir=.svn'
alias egrep='egrep --color=auto --exclude-dir=.svn'

alias sudo='sudo '
alias nless='/usr/share/nvim/runtime/macros/less.sh'
alias mux='tmuxinator'
alias hist='history | sort -uk 2 | sort -n | grep'

