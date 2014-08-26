#!/bin/bash

export CC=/usr/bin/gcc
export EDITOR='/usr/bin/vim'
export SVN_EDITOR='/usr/bin/vim'
export GIT_EDITOR='/usr/bin/vim'
export PLATFORM='mac'
export PATH="./bin/:/usr/local/heroku/bin:usr/local/share/npm/bin:$PATH"

export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

JAVA_HOME=/usr/bin/java
ANDROID_SDK=/Users/paulo/Project/Titanium/SDKs
export  PS1='\033[0;32m\]\u@\h\[\033[0;36m\] \w\[\033[0;33m\]$(git_prompt_info)\[\033[00m\] \n$ '
[ -e "$PROJECTS_DIR" ] || PROJECTS_DIR="$HOME/Projects"
export PROJECTS_DIR

. "$HOME/.bash_aliases"

if [ -f $HOME/.bash_aliases.blinq ]
  then
    . "$HOME/.bash_aliases.blinq"
fi

. "$HOME/.functions.sh"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export IRCNICK="pdelgado"
export IRCNAME="nam"
export IRCSERVER="irc.freenode.net"
