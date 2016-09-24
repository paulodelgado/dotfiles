# Show git branch when in a git repo
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
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

if [ -f '/usr/local/etc/bash_completion.d/git-completion.bash' ]; then
  source '/usr/local/etc/bash_completion.d/git-completion.bash'
fi

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
