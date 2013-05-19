#!/bin/bash
#
# Grabbed from https://github.com/mathiasbynens/dotfiles
#
cd "$(dirname "${BASH_SOURCE}")"

git pull
git submodule init
git submodule update

function doIt() {
  chmod 750 .ssh
  rsync --exclude=".git/" \
        --exclude=".gitmodules" \
        --exclude=".vim/bundle/*/.git" \
        --exclude="misc/" \
        --exclude=".DS_Store" \
        --exclude="bootstrap.sh" \
        --exclude="README.md" \
        -av . ~
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt

# Create cache dirs:
mkdir -p ~/.cache/vim/{swap,backup,undo}

if [[ `grep "# Added by dotfiles/bootstrap.sh" $HOME/.bash_profile` == "" ]]; then
cat >> $HOME/.bash_profile <<EOF

# Added by dotfiles/bootstrap.sh
if [ -f ~/.profile ]; then
  . ~/.profile
fi
EOF
fi

source ~/.profile
