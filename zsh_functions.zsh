# zsh: Place this in .zshrc after "source /Users/georgen/.iterm2_shell_integration.zsh".
iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}

alias pwd_name='basename $PWD'

work() {
  iterm2_set_user_var wname `pwd_name`
  tmux new -s `pwd_name`
}

