if [[ "$PWD" = "/c/Windows/System32" ]]; then
  cd ~
fi

if [[ "$PWD" = "/mnt/c/Windows/System32" ]]; then
  cd ~
fi

export PATH=$PATH:$HOME/.local/bin
