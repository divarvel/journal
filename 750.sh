#!/usr/bin/env bash

TODAY=$(date +'%Y-%m-%d')

ensure_db() {
  if [ ! -f "journal.db" ]
  then
    cat << EOF | sqlite3 journal.db
create table counts (date text, timestamp datetime, count integer);
EOF
  fi
}

ensure_file() {
  if [ ! -f "${1}.md" ]
  then
    echo "# ${1}" > "${1}.md"
    cat << EOF | sqlite3 journal.db
insert into counts (date, timestamp, count) values ('${1}', '$(date +'%Y-%m-%d %H:%M:%S')', 0);
EOF
  fi
}

count_words() {
  local word_count
  local modified
  local last_count
  word_count=$(tail -n+2 < "${1}.md"| wc -w)
  modified=$(date -d "@$(stat -c '%Z' "${1}.md")" +'%Y-%m-%d %H:%M:%S')
  last_count=$(cat << EOF | sqlite3 journal.db
select count from counts where date = '${1}' order by timestamp desc limit 1
EOF
  ) 
  echo "${word_count} words"
  if [ "$word_count" != "$last_count" ]
  then
    echo "Saving ${modified}"
    cat << EOF | sqlite3 journal.db
insert into counts (date, timestamp, count) values ('${1}', '${modified}', ${word_count})
EOF
  fi
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
  "ensure_file")
    ensure_file "${TODAY}"
    ;;
  "initdb")
    init_db
    ;;
  *)
    ensure_db
    ensure_file "${TODAY}"
    zellij --layout layout.kdl
    ;;
esac
