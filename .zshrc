export EDITOR='vim'
export PROJECTS=~/code

#
# Path
#
path=(
	./bin
	node_modules/.bin
	$HOME/.dotfiles/bin
	$HOME/.rbenv/shims
	/usr/local/bin
	/usr/local/sbin
	$path
)
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Rbenv
#eval "$(rbenv init -)"

#
# Aliases
#
alias r='. ~/.zshrc'
alias e='$EDITOR ~/.dotfiles'
alias dnsflush="sudo killall -HUP mDNSResponder"
if $(gls &>/dev/null); then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# Tier 1
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

# Tier 3
alias myip="ifconfig en0 | grep "inet" | grep -v inet6 | sed 's/.*inet \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'"
alias apache-edit="sudo open /etc/apache2/httpd.conf"
alias apache-restart="sudo /usr/sbin/apachectl restart"


# Create a new shell script
new-script() { 
  echo "#!/bin/bash" > $1
  chmod +x $1 
}

# GRC colorizes nifty unix tools all over the place
if $(grc &>/dev/null) && ! $(brew &>/dev/null); then
  source `brew --prefix`/etc/grc.bashrc
fi

#
# Secrets
#
if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# load every completion after autocomplete loads
#for file in ${(M)config_files:#*/completion.zsh}
#do
  #source $file
#done

#unset config_files
#

#
# Zsh Config
#
if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
#setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt MARK_DIRS		# append a / to dir names
setopt complete_aliases # don't expand aliases _before_ completion has finished
zle -N newtab
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # matches case insensitive for lowercase
zstyle ':completion:*' insert-tab pending # pasting with tabs doesn't perform completion

# zsh sets the shell to vi mode automatically if EDITOR is set to vim.  It was
# tricky to track down why ctrl+r wasn't doing history search (its not bound in
# vi mode), make it explicit.  `bindkey -e` is emacs mode.
#
# To do:
#  add ctrl+a, ctrl+e and other basics
#
# To read: 
# 	http://dougblack.io/words/zsh-vi-mode.html
# 	man zshzle
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

if (( $+commands[git] ))
then
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

#ruby_version() {
  #if (( $+commands[rbenv] ))
  #then
    #echo "$(rbenv version | awk '{print $1}')"
  #fi

  #if (( $+commands[rvm-prompt] ))
  #then
    #echo "$(rvm-prompt | awk '{print $1}')"
  #fi
#}

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

export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push)\n› '
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

