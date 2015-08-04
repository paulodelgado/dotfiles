
pcd() {
  cd "$PROJECTS_DIR/$1"
  if [ -e .git/safe -a ! -L .git/bin ]; then
    ln -s ../bin .git
  fi
}

pclone() {
  local url basename example new
  if [ x-f = "x$1" ]; then
    shift
    rm -rf "$PROJECTS_DIR/`basename $1 .git`"
  fi
  basename="`basename $1 .git`"
  if [ ! -d "$PROJECTS_DIR/$basename" ]; then
    new=1
    case "$1" in
      *:*) url="$1" ;;
      */*) url="git@github.com:$1.git" ;;
      *)   url="git@github.com:hashrocket/$1.git" ;;
    esac
    git clone "$url" "$PROJECTS_DIR/$basename" || return 1
    for example in "$PROJECTS_DIR/$basename"/config/*.example.yml; do
      cp "$example" "${example%.example.yml}.yml"
    done 2>/dev/null
    if [ -f "$PROJECTS_DIR/$basename/.rvmrc" ] && command -v __rvm_trust_rvmrc >/dev/null; then
      __rvm_trust_rvmrc "$PROJECTS_DIR/$basename/.rvmrc"
    fi
  fi
  pcd "$basename"
  ln -sf ../bin .git
  mkdir -p .git/safe
  if [ ! -f .git/hooks/post-rewrite ]; then
    cat > .git/hooks/post-rewrite <<EOS
#!/bin/sh

GIT_DIR="\$(dirname "\$(dirname "\$0")")"
export GIT_DIR

case "\$1" in
  rebase) exec "\$GIT_DIR/hooks/post-merge" 0 rebase ;;
esac
EOS
  fi
  if [ ! -f .git/hooks/pre-commit ]; then
    echo '#!/bin/sh' > .git/hooks/pre-commit
    echo 'git diff --exit-code --cached -- Gemfile Gemfile.lock >/dev/null || bundle check' >> .git/hooks/pre-commit
  fi
  if [ ! -f .git/hooks/ctags ]; then
    echo '#!/bin/sh' > .git/hooks/ctags
    echo 'rm -f .git/tags' >> .git/hooks/ctags
    echo 'ctags --tag-relative -f .git/tags --exclude=.git --exclude=db --exclude=public/uploads --exclude=vendor --exclude=tmp --languages=-javascript,html,sql -R' >> .git/hooks/ctags
    chmod +x .git/hooks/ctags
    for basename in post-checkout post-commit post-merge; do
      echo '#!/bin/sh' > .git/hooks/$basename
      echo '$GIT_DIR/hooks/ctags >/dev/null 2>&1 &' >> .git/hooks/$basename
      chmod +x .git/hooks/$basename
    done
    .git/hooks/ctags
  fi
  echo 'if command -v hookup >/dev/null; then' >> .git/hooks/post-checkout
  echo '  hookup post-checkout "$@"' >> .git/hooks/post-checkout
  echo "fi" >> .git/hooks/post-checkout
  if [ -n "$new" -a -x script/setup ]; then
    script/setup
  elif [ -n "$new" -a -x bin/setup ]; then
    bin/setup
  fi
}

# Tab completion
if [ -n "$BASH_VERSION" ]; then
  _pcd()
  {
    local cur projects

    [ -r "$PROJECTS_DIR" ] || return 0

    eval 'COMPREPLY=()'
    cur=${COMP_WORDS[COMP_CWORD]}
    projects=$(\ls "$PROJECTS_DIR")

    if [ $COMP_CWORD -eq 1 ]; then
      eval 'COMPREPLY=( $(compgen -o filenames -W "$projects" $cur) )'
    fi

    return 0
  }
  complete -F _pcd pcd pclone
elif [ -n "$ZSH_VERSION" ]; then
  compctl -/ -S '' -W "$PROJECTS_DIR" pcd pclone
fi

# Show git branch when in a git repo
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

function rvm_version {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  [ "$version" != "" ] && version="@$version"
  local full="$version$gemset"
  [ "$full" != "" ] && echo "$full "
}

git_prompt_info () {
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
    local d
    local s
    # Rebasing
    if [ -d "$g/rebase-apply" ] ; then
      if test -f "$g/rebase-apply/rebasing" ; then
        r="|REBASE"
      fi
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    # Interactive rebase
    elif [ -f "$g/rebase-merge/interactive" ] ; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    # Merging
    elif [ -f "$g/MERGE_HEAD" ] ; then
      r="|MERGING"
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      if [ -f "$g/BISECT_LOG" ] ; then
        r="|BISECTING"
      fi
      if ! b="$(git symbolic-ref HEAD 2>/dev/null)" ; then
        if ! b="$(git describe --exact-match HEAD 2>/dev/null)" ; then
          b="$(cut -c1-7 "$g/HEAD")..."
        fi
      fi
    fi

    # Dirty Branch
    local newfile='?? '
    if [ -n "$ZSH_VERSION" ]; then
      newfile='\?\? '
    fi
    d=''
    s=$(git status --porcelain 2> /dev/null)
    [[ $s =~ "$newfile" ]] && d+='+'
    [[ $s =~ "M " ]] && d+='*'
    [[ $s =~ "D " ]] && d+='-'

    if [ -n "${1-}" ]; then
      printf "$1" "${b##refs/heads/}$r$d"
    else
      printf "(%s) " "${b##refs/heads/}$r$d"
    fi
  fi
}

mux() {
  local name cols
  if [ -n "$1" ]; then
    cd $HOME/blinqmedia/$1
  fi
  name="$(basename $PWD | sed -e 's/\./-/g')"
  cols="$(tput cols)"
  if ! $(tmux has-session -t $name &>/dev/null); then
    tmux new-session -d -n code -s $name -x${cols-150} -y50 && \
    tmux split-window -t $name:0 \; \
      new-window -a -d -n server -t $name:0 \; \
      select-layout -t $name main-vertical &>/dev/null \; \
      send-keys -t $name:0.1 'vim' C-m
  fi
  tmux attach-session -t $name
}

if [ -f '/usr/local/etc/bash_completion.d/git-completion.bash' ]; then
  source '/usr/local/etc/bash_completion.d/git-completion.bash'
fi

bam_screensaver() {
  awk 1 ORS=' ' /Users/paulo/Projects/blinq_ad_manager/app/models/*.rb
  bam_screensaver;
}

# From http://christian.gen.co/macbook-developer-setup/
export MARKPATH=$HOME/.marks
function jump {
cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
rm -i $MARKPATH/$1
}
function marks {
\ls -l $MARKPATH | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
alias j="jump"
alias m="mark"

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l | xargs -n1 basename)
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark
