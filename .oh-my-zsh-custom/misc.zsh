if [[ "$PWD" = "/c/Windows/System32" ]]; then
  cd ~
fi

if [[ "$PWD" = "/mnt/c/Windows/System32" ]]; then
  cd ~
fi

export PATH=$PATH:$HOME/.local/bin

# This is an altered version of git_main_branch
git_remote_branch() {
  command git rev-parse --git-dir &> /dev/null || return
  local ref
  for ref in refs/remotes/origin/{main,trunk,releases/ops}
  do
    if command git show-ref -q --verify $ref
    then
      echo $ref | sed -e 's|refs/remotes/origin/\(.*\)|\1|'
      return
    fi
  done
  echo master
}
