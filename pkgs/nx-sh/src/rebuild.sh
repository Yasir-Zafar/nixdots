# nh wrappers: nx os / nx home
run_os() {
  local mode="${1:-switch}"
  shift || true
  case "$mode" in
    build) nh os build "$os" -o "$links/os" "$@" ;;
    switch | boot | test) nh os "$mode" "$os" "$@" ;;
    *) err "nx os: unknown mode '$mode' (switch|boot|test|build)"; exit 2 ;;
  esac
}

run_home() {
  local mode="switch" backup=0 arg
  for arg in "$@"; do
    case "$arg" in
      switch | build) mode="$arg" ;;
      -b | --backup) backup=1 ;;
      *) err "nx home: unknown option '$arg' (switch|build|-b)"; exit 2 ;;
    esac
  done
  local -a extra=()
  [ "$mode" = build ] && extra=(-o "$links/home")
  if [ "$backup" = 1 ]; then
    HOME_MANAGER_BACKUP_EXT=bak nh home "$mode" "$hm" "${extra[@]}"
  else
    nh home "$mode" "$hm" "${extra[@]}"
  fi
}
