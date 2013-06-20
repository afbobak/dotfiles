# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=$HOME/bin:$PATH

  if [ "${TERM}" = "Linux" ] && [ -e "${HOME}/bin/base16-default.dark.sh" ] ; then
    source "${HOME}/bin/base16-default.dark.sh"
  fi
fi

if [ -d "/usr/local/sbin" ] ; then
  PATH=/usr/local/sbin:$PATH
fi

if [ -d "/usr/local/bin" ] ; then
  PATH=/usr/local/bin:$PATH
fi

export PATH

# Aliases
# #######

if [[ `ls --help 2> /dev/null | grep color` == "" ]] ; then
  alias ls='ls -hFG'
  alias ll='ls -aAlhFG'
else
  alias ls='ls -hF --color=tty'
  alias ll='ls -alhF --color=tty'
fi
alias grep='grep --color=tty'

# Git status nicety
function g {
 if [[ $# > 0 ]]; then
   git $@
 else
   git status --short --branch
 fi
}
function parse_git_branch() {
  NAME=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`
  if [[ "$NAME" == "master" ]]; then
    echo -en "\033[35m#$NAME\033[00m"
  elif [[ "$NAME" == "develop" ]]; then
    echo -en "\033[32m#$NAME\033[00m"
  elif [[ "$NAME" == "" ]]; then
    echo -en ""
  else
    echo -en "\033[36m#$NAME\033[00m"
  fi
}

# Git flow
alias gff='git flow feature'

# Environment variables
# #####################

export EDITOR=vi
export TERM=xterm-256color

LS_COLORS='no=00:di=34:tw=33;01:ow=33;01:ex=32:ln=36'
LS_COLORS=$LS_COLORS':fi=00:pi=00:so=00:bd=00:cd=00:or=00:mi=00'
LS_COLORS=$LS_COLORS':*.tgz=31:*.gz=31:*.zip=31:*.bz2=31:*.tar=31'
export LS_COLORS

if [[ "${USER}" == "root" ]]; then
  PS1="\[\033[31m\]==== YOU ARE ROOT ====\n\u\[\033[00m\]@\[\033[34m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$(parse_git_branch)> "
else
  PS1="\[\033[31m\]\u\[\033[00m\]@\[\033[34m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$(parse_git_branch)> "
fi
