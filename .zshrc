export EDITOR='vim'

#
# Path
#
path=(
  ./bin
  ./node_modules/.bin
  $HOME/.yarn/bin
  $HOME/bin
  $HOME/.node/bin
  $HOME/.rbenv/shims
  /usr/local/bin
  /usr/local/opt/postgresql@9.4/bin
  $HOME/.rvm/bin
  $path
)
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

#
# Aliases
#
alias r='. ~/.zshrc'
alias e='$EDITOR ~/.zshrc'
alias ..="cd .."
alias ...="cd ../.."
function o() { open ${1:-./} }
function m() { $EDITOR ${1:-./} }
alias -g D='$(basename $PWD)'

alias d="docker"
alias dc="docker-compose"
alias dcb="docker-compose build"
alias dcr="docker-compose run"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcl="docker-compose logs -f -t"

# Start a shell in the container based on your current directories name (by default).
dsh() {
  command="docker-compose run ${1:-$(basename "$PWD")} bash"
  echo $command
  eval $command
}

alias here="pwd | tr '\n' ' '| pbcopy"
alias cpy="pbcopy"
alias pst="pbpaste"

alias ls="gls -F --color"
alias l="gls -lAh --color"

# Network
alias dnsflush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias whois="whois -h whois-servers.net"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Create a new shell script
new-script() {
  echo "#!/bin/env bash" > $1
  chmod +x $1 
  $EDITOR $1
}

# Shortcut to make a file executable
alias x="chmod u+x"

#
# Git
#
alias g='git'

alias gl="clear && git log"
alias gll="clear && git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias glp="clear && git log -p"

alias gs="clear && git status -sb"
alias gd='clear && git diff --color-words'
alias gdc='clear && git diff --cached'

alias push="git push -u origin head"
alias pull="git pull && git dm"
alias stash='git stash -u'
alias pop='git stash pop'
alias pick='git cherry-pick'

# Commiting
function ga() { git add ${@:-.} }
alias gA="git add -A :/"
alias gap="clear && git add -p"
alias gc='git commit'
alias gca='git commit -a'

# Branches
alias gco='git checkout'
alias gb='git branch'
alias gbn='git checkout -b'

#
# Ruby
#
alias be="bundle exec"
alias migrate='bundle exec rake db:migrate'
alias rollback='bundle exec rake db:rollback'
alias seed="bundle exec rake db:seed"
alias console="heroku run console"

# Rbenv
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

# shell thing
rbenv() {
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  shell)
    eval `rbenv "sh-$command" "$@"`;;
  *)
    command rbenv "$command" "$@";;
  esac
}

# Turn on autocompletion.
autoload -U compinit && compinit

#
# Zsh Config
#
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
HISTFILE=~/.history # 
HISTSIZE=10000
SAVEHIST=10000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
setopt APPEND_HISTORY # adds history
setopt SHARE_HISTORY # share history between tabs
setopt EXTENDED_HISTORY # add timestamps to history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
setopt PROMPT_SUBST
#setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt MARK_DIRS    # append a / to dir names
#setopt complete_aliases # don't expand aliases _before_ completion has finished
zle -N newtab
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # matches case insensitive for lowercase
zstyle ':completion:*' insert-tab pending # pasting with tabs doesn't perform completion
autoload zmv # nice multi-move util
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page

# zsh sets the shell to vi mode automatically if EDITOR is set to vim.  It was
# tricky to track down why ctrl+r wasn't doing history search (its not bound in
# vi mode), make it explicit.  `bindkey -e` is emacs mode.
#
# To do:
#  add ctrl+a, ctrl+e and other basics
#
# To read:
#   http://dougblack.io/words/zsh-vi-mode.html
#   man zshzle
bindkey -v
bindkey "^R" history-incremental-search-backward
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char

# Vi-mode
function zle-keymap-select zle-line-init {
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish {
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select


#
# Prompt
#
autoload colors && colors
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] )); then
  git="$commands[git]"
else
  git="/usr/bin/git"
  echo 'using basic git?'
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

heroku_info() {
  if [ -n "${HEROKU_APP+x}" ]; then
    echo "☁️  $HEROKU_APP"
  fi
}

#
# Prompt
#
export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push) 💎  $(ruby_version)  $(heroku_info)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  print -Pn "\e]2;%~\a"
}


# Only init nvm when its used
nvm() {
  export NVM_DIR="/Users/mfrawley/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}


# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /Users/mfrawley/code/scrimmage/containers/electron-quick-start/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/mfrawley/code/scrimmage/containers/electron-quick-start/node_modules/tabtab/.completions/electron-forge.zsh
