export PATH=$HOME/.nodebrew/current/bin:$PATH

export PATH=$HOME/local/bin:$PATH

export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
export GOPAHT=$HOME/gocode
export PATH=$HOME/gocode/bin:$PATH

export PATH=$HOME/android-sdk/platform-tools:${PATH}
export PATH=$HOME/android-sdk/tools:$PATH
export ANDROID_HOME=$HOME/android-sdk

export PATH=$HOME/.nodebrew/current/bin:$PATH

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#####

HISTSIZE=100
SAVEHIST=100
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if type dircolors > /dev/null
then
  eval "$(dircolors -b)"
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

#######

peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^@' peco-cdr

# ref. http://qiita.com/kp_ohnishi/items/3009e2083831af3a7c5c
# ref. for uniquness http://qiita.com/arcizan/items/9cf19cd982fa65f87546
peco-select-history () {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$( \
    history -n 1 | \
    awk '!a[$0]++' | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
