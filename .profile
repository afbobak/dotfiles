# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH=$HOME/bin:$PATH

  if [ -e "${HOME}/bin/base16-default.dark.sh" ] && [ "${TERM}" = "Linux" ] ; then
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
  alias ll='ls -AlhFG'
else
  alias ls='ls -hF --color=tty'
  alias ll='ls -AlhF --color=tty'
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

PS1="\e[31m\]\u\e[0m@\e[34m\h\e[0m(\W)> "
