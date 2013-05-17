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

# Git flow
alias gff='git flow feature'

# Environment variables
# #####################

export EDITOR=vi
export TERM=xterm-256color

PS1="\[\033[31m\]\u\[\033[00m\]@\[\033[34m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]> "
