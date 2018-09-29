# Source .profile; other shells read this file
if [ -r ~/.profile ]; then . ~/.profile; fi

# Source .bashrc if this is an interactive shell
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

