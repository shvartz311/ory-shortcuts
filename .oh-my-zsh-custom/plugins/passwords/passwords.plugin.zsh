generate_password() {
  head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c${1:-20}
}

print_password() {
  PREFIX_LENGTH=0
  SUFFIX_LENGTH=0
  HIDE_LENGTH=false

  while true; do
    case "$1" in
      -p | --prefix-characters-shown ) PREFIX_LENGTH="$2"; shift 2 ;;
      -s | --suffix-characters-shown ) SUFFIX_LENGTH="$2"; shift 2 ;;
      -hl | --hide-length ) HIDE_LENGTH=true; shift ;;
      -- ) shift; break ;;
      * ) break ;;
    esac
  done

  LENGTH=${#1}
  PREFIX=${1:0:$PREFIX_LENGTH}

  if [[ $SUFFIX_LENGTH -eq 0 ]]; then
    SUFFIX=""
  else
    SUFFIX=${1:(-$SUFFIX_LENGTH)}
  fi


  if [[ $(expr $PREFIX_LENGTH + $SUFFIX_LENGTH) -gt $LENGTH ]]; then
    echo "$1"
  else
    if [[ $HIDE_LENGTH == 'true' ]]; then
      echo "$PREFIX""[...]""$SUFFIX"
    else
      stars=$(printf '%*s' $(expr $LENGTH - $PREFIX_LENGTH - $SUFFIX_LENGTH) '')
      echo "$PREFIX${stars// /*}$SUFFIX"
    fi
  fi

  unset PREFIX
  unset SUFFIX
}
