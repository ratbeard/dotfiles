export EDITOR='vim'
export PROJECTS=~/code

#
# Path
#
path=(
  ./bin
  node_modules/.bin
  $HOME/repos/chrome/depot_tools
  $HOME/bin
  $HOME/.node/bin
  $HOME/.rbenv/shims
  /usr/local/bin
  /usr/local/sbin
  $path
)
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Rbenv
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

#
# Aliases
#
# Tier 1
alias r='. ~/.zshrc'
alias e='$EDITOR ~/dotfiles'
alias ..="cd .."
alias ...="cd ../.."
function o() { open ${1:-./} }
function m() { $EDITOR ${1:-./} }

# Tier 2
function cdl { cd $1; ls; }
alias here="pwd | tr '\n' ' '| pbcopy"
alias goto='cd `pbpaste`' 
alias cpy="pbcopy"
alias pst="pbpaste"
# Trim new lines and copy to clipboard
#alias c="tr -d '\n' | pbcopy"

if $(gls &>/dev/null); then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# Tier 3
alias dnsflush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias whois="whois -h whois-servers.net"

# IP
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
[ -e "${jscbin}" ] && alias jsc="${jscbin}"
unset jscbin

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Create a new shell script
new-script() { 
  echo "#!/bin/bash" > $1
  chmod +x $1 
  $EDITOR $1
}

# GRC colorizes unix tools
if $(grc &>/dev/null) && ! $(brew &>/dev/null); then
  source `brew --prefix`/etc/grc.bashrc
fi

# Pipe public key to clipboard
alias pubkey="more ~/.ssh/id_dsa.public | pbcopy | echo '=> Public key copied to pasteboard.'"
#
# Git
#

# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] )); then
  alias git=$hub_path
fi

alias g='git'
alias clone="git clone"

# Viewing
alias gl="git log"
alias gll="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias glp="git log -p"
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
# alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           # perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
alias gd='git diff'
alias gdc='git diff --cached'

# Commiting
function ga() { git add ${@:-./} }
alias gA="git add -A :/"
alias gap="git add -p"
alias gc='git commit'
alias gca='git commit -a'

# Branches
alias gco='git checkout'
alias gb='git branch'
alias gbn='git checkout -b'

# Remotes
# alias gp='git push origin HEAD'
# alias gl='git pull --prune'

# Git svn
alias gsr="git svn rebase"
alias gsd="git svn dcommit"



#
# Ruby
#
alias rb='rbenv local 1.8.7-p358'
alias be="bundle exec"
alias migrate='bundle exec rake db:migrate db:test:clone'
alias seed="bundle exec rake db:seed"

# rehash shims
#rbenv rehash 2>/dev/null

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


#
# tmux
#
function tm() {
  [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
  tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}

function __tmux-sessions() {
 local expl
 local -a sessions
 sessions=( ${${(f)"$(command tmux list-sessions)"}/:[ $'\t']##/:} )
 _describe -t sessions 'sessions' sessions "$@"
}
#compdef __tmux-sessions tm



#
# Svn
#
alias svns="svn st"
alias svnu="svn up"
alias svnkill="find . -name .svn -print0 | xargs -0 rm -rf"

# Show last log entries, default 5
function svnl () {
  svn log -l ${1:-5}
}
# Color diffs for SVN, http://www.zalas.eu/viewing-svn-diff-result-in-colors
function svnd () {
  svn diff "${@}" | colordiff | less -R;
}

# Pipe diff to mate
function svndm () {
  if [ "$1" != "" ]; then
    svn diff $@ | mate;
  else
    svn diff | mate;
  fi
}


#
# Secrets
#
if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

#
# Zsh Config
#
# PROMPT variable is used below...
#if [[ -n $SSH_CONNECTION ]]; then
  #export PS1='%m:%3~$(git_info_for_prompt)%# '
#else
  #export PS1='%3~$(git_info_for_prompt)%# '
#fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
setopt APPEND_HISTORY # adds history
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
export LANG="en_US.UTF-8" # Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
setopt PROMPT_SUBST
#setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt MARK_DIRS    # append a / to dir names
setopt complete_aliases # don't expand aliases _before_ completion has finished
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

#rb_prompt() {
  #if ! [[ -z "$(ruby_version)" ]]
  #then
    #echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  #else
    #echo ""
  #fi
#}

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
  #title "zsh" "%m" "%55<...<%~"
  #set_prompt
  # Just the cwd
  print -Pn "\e]2;%~\a"
}


# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}



#
# Functions
#
# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* *
  fi
}

