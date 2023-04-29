#!/usr/bin/env bash

TODAY=$(date +'%Y-%m-%d')

ensure_file() {
  if [ ! -f "${1}.md" ]
  then
    echo "# ${1}" > "${1}.md"
  fi
}

count_words() {
  local word_count
  word_count=$(tail -n+2 < "${1}.md"| wc -w)
  echo "${word_count} words"
}


case "$1" in
  "watch")
    watch -t ./750.sh count
    ;;
  "edit")
    hx "${TODAY}.md"
    ;;
  "count")
    count_words "${TODAY}"
    ;;
  *)
    ensure_file "${TODAY}"
    zellij --layout layout.kdl
    ;;
esac
