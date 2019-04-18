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

export PATH

if [ -z $JAVA_HOME ] ; then
  if [[ `uname` = "Darwin" ]]; then
    JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
  elif [[ `uname` = "Linux" ]]; then
    JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
  fi
  export JAVA_HOME
fi

# See https://bbs.archlinux.org/viewtopc.php?id=167081
GPG_AGENT=/usr/bin/gpg-agent
if [ -x "${GPG_AGENT}" ]; then
  # Check validity of GPG_SOCKET (in case of session crash)
  GPG_AGENT_INFO_FILE="${HOME}/.gpg-agent-info"
  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    GPG_AGENT_PID=`cat ${GPG_AGENT_INFO_FILE} | grep GPG_AGENT_INFO | cut -f2 -d:`
    GPG_PID_NAME=`cat /proc/${GPG_AGENT_PID}/comm`
    if [ ! "x${GPG_PID_NAME}" = "xgpg-agent" ]; then
      rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
    else
      GPG_SOCKET=`cat "${GPG_AGENT_INFO_FILE}" | grep GPG_AGENT_INFO | cut -f1 -d: | cut -f2 -d=`
      if ! test -S "${GPG_SOCKET}" -a -O "${GPG_SOCKET}"; then
        rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
      fi
    fi
    unset GPG_AGENT_PID GPG_SOCKET GPG_PID_NAME SSH_AUTH_SOCK
  fi

  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    eval "$(cat "${GPG_AGENT_INFO_FILE}")"
    eval "$(cut -d= -f 1 "${GPG_AGENT_INFO_FILE}" | xargs echo export)"
    export GPG_TTY=$(tty)
  else
    ${GPG_AGENT} -s --enable-ssh-support --allow-preset-passphrase --daemon
  fi
fi

if [ -f /usr/bin/keychain ]; then
  eval `keychain --eval id_rsa`
fi

# Aliases
# #######

if [[ `ls --help 2> /dev/null | grep color` == "" ]] ; then
  alias ls='ls -hFG'
  alias ll='ls -aAlhFG'
else
  alias ls='ls -hFv --color=tty'
  alias ll='ls -alhFv --color=tty'
fi
alias tm='tmux attach || tmux'
alias v='vim'
alias grep='grep --color=tty'
alias shutdown='echo "WARNING: to shutdown manually type: /sbin/shutdown"'
alias poweroff='echo "WARNING: to poweroff manually type: /sbin/poweroff"'
alias reboot='echo "WARNING: to reboot manually type: /sbin/reboot"'

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
  PS1="\[\033[41m\]\u\[\033[00m\]@\[\033[34m\]\h:\[\033[01;34m\]\W\[\033[00m\]\$(parse_git_branch)> "
else
  PS1="\[\033[31m\]\u\[\033[00m\]@\[\033[34m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$(parse_git_branch)> "
fi
