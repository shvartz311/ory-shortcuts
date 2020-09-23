cp ~/.kube/config /mnt/c/Users/jdnovick/.kube/config

sudo mount --bind /mnt/c /c

if [[ "$PWD" = "/c/Windows/System32" ]]; then
  cd ~
fi

if [[ "$PWD" = "/mnt/c/Windows/System32" ]]; then
  cd ~
fi
