export EDITOR="nvim"
export DIFFPROG="nvim -d"
export BAT_THEME="TwoDark"
export BAT_STYLE="changes,header,numbers"
export BAT_PAGER=""

export PATH="$HOME/bin:$PATH:$HOME/.cabal/bin:$HOME/.local/bin"

# Add RubyGems to PATH, if installed
ruby_path=$(find $HOME/.gem -name bin -not -path '*gems*' -type d | sort | tail -n 1 2>/dev/null)
if [[ ! -z $ruby_path ]]; then
    export PATH="$PATH:$ruby_path"
fi

if [[ -x "$(command -v startx)" && ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec ssh-agent startx
fi

