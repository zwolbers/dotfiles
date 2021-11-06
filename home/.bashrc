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
    local -r exit=$?    # Capture the exit code before it's overwritten
    PS1=""              # Reset the prompt

    # Add a status line whenever something "interesting" happens
    if [[ -n $cmd_start_time ]]; then       # Only display once
        # Show the exit code on failure (Bold, Red)
        [[ $exit -ne 0 ]] && PS1+="\[\e[1;31m\]$exit\[\e[m\]"

        # Show the execution time for commands that took a while
        local duration=$(expr $SECONDS - ${cmd_start_time:-0})
        if [[ $duration -ge 5 ]]; then
            local str="$((duration%60 ))s" &&
                ((duration/=60)) && str="$((duration%60))m $str" &&
                ((duration/=60)) && str="$((duration%24))h $str" &&
                ((duration/=24)) && str="$((duration   ))d $str"

            [[ -n $PS1 ]] && PS1+="\011"    # Add a tab if needed (ASCII, octal)
            PS1+="\[\e[2;37m\]$str\[\e[m\]" # (Dim, Gray)
        fi

        # If we have something to report, then the main prompt should
        # follow on a new line
        [[ -n $PS1 ]] && PS1+="\n"

        # Indicate we've already evaluated the previous command's status
        cmd_start_time=
    fi

    # Set the title if this is an xterm
    [[ $TERM == xterm* ]] || [[ $TERM == rxvt* ]] &&
        PS1+="\[\e]0;\u@\h: \w\a\]"             # user@host: path

    # Construct the main prompt
    [[ -n $SSH_CLIENT ]]    && PS1+="\[\e[2m\]" # If ssh'd (Dim)
    [[ $EUID -eq 0 ]]       && PS1+="\[\e[7m\]" # If root (Highlight)
    PS1+="\[\e[1;32m\]\u@\h\[\e[m\]"            # user@host (Bold, Green)
    PS1+=":"                                    # :
    PS1+="\[\e[1;34m\]\w\[\e[m\]"               # path (Bold, Blue)

    # Determine if the prompt is too long
    local mock_prompt="\u@\h:\w\\$ "            # Ignore control codes
    mock_prompt=${mock_prompt@P}                # Expand everything
    [[ $(($COLUMNS-${#mock_prompt})) -le 20 ]] &&
        PS1+="\n\[\e[1;90m\]\u@\h\]\e[m\]"      # Add a mini prompt (Bold, Dark Gray)

    # Finish the prompt
    PS1+="\\$ "                                 # $ for user, # for root

    # Emphasize whatever the user types.  $PS0 will be reset everything.
    PS1+="\[\e[1m\]"                            # (Bold)
}
PROMPT_COMMAND="prompt_command"

# Reset all text properties before command is run
PS0+="\[\e[m\]"

function pre_command() {
    # The debug trap is called for a number of reasons, most of which we
    # don't care about.  The following tries to filter out any commands
    # that weren't entered at the prompt.  Complex expressions might
    # slip by, but whatever.  This covers 99% of all use cases.
    [[ -n "$COMP_LINE" ]] && return                         # Bash completion
    [[ "$PROMPT_COMMAND" == *"$BASH_COMMAND"* ]] && return  # Prompt components
    [[ "$BASH_COMMAND" == "__fzf_history__" ]] && return    # fzf key bindings

    # Note that using $EDITOR to create commands causes some weird
    # behavior.  The following filters out implicit background commands,
    # which fixes some of the problems with setting the cmd start time.
    # Nonetheless, you'll still see behavior like the following:
    #
    #   user@host:~$ ...        <-- Some command created by $EDITOR.
    #   cd my/path/             <-- Command echo of what was returned by
    #                               $EDITOR (as expected).
    #   pre_command             <-- The name of this function.  Not sure
    #                               why this is printed; perhaps command
    #                               echo is still on.
    #   user@host:~$            <-- The command completes; a new prompt
    #                               is printed.  Note the directory did
    #                               NOT update.
    #                           <-- Wait for a bit, then hit enter to
    #                               draw a new prompt.
    #   10s                     <-- The new prompt prints the time since
    #                               `cd my/path/` was started.
    #   user@host:~/my/path$    <-- The directory is printed, everything
    #                               returns to normal.
    [[ "$BASH_COMMAND" == 'fc -e "${VISUAL:-${EDITOR:-vi}}"' ]] && return
    [[ "$BASH_COMMAND" == "${VISUAL:-${EDITOR:-vi}} /tmp/bash-"* ]] && return

    # Set a command's start time only once.  If it was set on each
    # function invocation, chained commands would keep resetting the
    # timer.  It'll get cleared out later when the prompt is redrawn.
    cmd_start_time=${cmd_start_time:-$SECONDS}
}
trap pre_command debug

function cleanup() {
    # Fidget with the history so that duplicates are properly removed
    history -n  # Read lines not already read from ~/.bash_history
    history -w  # Overwrite ~/.bash_history with current history list
    history -c  # Clear history list
    history -r  # Append contents of ~/.bash_history to history list
}
trap cleanup exit

# Enable fzf magic.  Note that even though 'vi' mode was already enabled
# in ~/.inputrc, it must be set again for fzf to properly detect it.
set -o vi
[[ -f /usr/share/fzf/key-bindings.bash ]] && . /usr/share/fzf/key-bindings.bash
[[ -f /usr/share/fzf/completion.bash ]] && . /usr/share/fzf/completion.bash

# Enable tmuxinator bash completion, if installed
tmuxinator_bash_path=$([[ -d ~/.gem ]] && find ~/.gem -name tmuxinator.bash | sort | tail -n 1 2>/dev/null)
[[ -n $tmuxinator_bash_path ]] && . $tmuxinator_bash_path

# Enable autojump, if installed
[[ -f /etc/profile.d/autojump.bash ]] && . /etc/profile.d/autojump.bash

function dotfile_import() { (
    set -e
    local -r dot_dir="${HOME}/Projects/dotfiles/home"   # Assume installation path

    local -r src_file="$(readlink -f $1)"
    local -r src_dir="$(dirname "$src_file")/"

    [[ $src_dir == $HOME* ]]    || { echo "Error: The file isn't in '$HOME'"; exit 1; }
    [[ -d $dot_dir ]]           || { echo "Error: The directory '$dot_dir' does not exist"; exit 1; }

    local -r root_file="${src_file#$HOME}"

    local -r dst_file="${dot_dir}${root_file}"
    local -r dst_dir="$(dirname "$dst_file")/"

    echo "Moving ~$root_file"
    echo

    set -x
    mkdir -p "$dst_dir"
    mv "$src_file" "$dst_dir"
    ln -rs "$dst_file" "$src_dir"
)
}

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

