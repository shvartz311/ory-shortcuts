cp ~/.kube/config /mnt/c/Users/Joshua/.kube/config

if [[ "$PWD" = "/c/Windows/System32" ]]; then
  cd ~
fi

if [[ "$PWD" = "/mnt/c/Windows/System32" ]]; then
  cd ~
fi
