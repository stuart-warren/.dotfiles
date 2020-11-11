c() {
  local cols sep google_history open query
  cols=$(( COLUMNS / 3 ))
  sep='{::}'
  query=''
  if [ ! -z "$1" ]; then
    query="--query=${*}"
  fi

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi ${query} | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}
