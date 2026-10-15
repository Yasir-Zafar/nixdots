storage() {
  local action="report" yes=0 browsers=0 steam=0 trash=0 hard=0 arg
  for arg in "$@"; do
    case "$arg" in
      report | clean) action="$arg" ;;
      -y | --yes) yes=1 ;;
      --browsers) browsers=1 ;;
      --steam-shaders) steam=1 ;;
      --trash) trash=1 ;;
      --hard) hard=1 browsers=1 steam=1 trash=1 ;;
      *) err "nx storage: unknown option '$arg'"; exit 2 ;;
    esac
  done

  local cache="$HOME/.cache" share="$HOME/.local/share"
  # regenerable caches: safe to delete, programs rebuild them on demand
  # ~/.cache/nix (flake + tarball fetcher cache) is only in --hard: wiping it makes the
  # next rebuild download every input again
  local -a paths=("$cache/uv" "$cache/JetBrains" "$cache/appimage-run" "$cache/mesa_shader_cache" "$cache/thumbnails" "$cache/pip")
  [ "$hard" = 1 ] && paths+=("$cache/nix")
  if [ "$browsers" = 1 ]; then
    # wiping a running browser's cache can corrupt its state
    if pgrep '^\.?(zen|firefox|chromium)' >/dev/null 2>&1; then
      caution "a browser is running, skipping browser caches (close it and rerun)"
    else
      paths+=("$cache/zen" "$cache/chromium" "$cache/mozilla")
    fi
  fi
  [ "$steam" = 1 ] && paths+=("$share/Steam/steamapps/shadercache")
  [ "$trash" = 1 ] && paths+=("$share/Trash/files" "$share/Trash/info")

  human() { numfmt --to=iec --suffix=B "$1"; }
  size() { du -sb "$1" 2>/dev/null | cut -f1; }

  local p b total=0
  step "Disk"
  df -h / | tail -n +2 | sed 's/^/  /'
  heading "Safe to delete (regenerable caches)"
  for p in "${paths[@]}"; do
    [ -d "$p" ] || continue
    b=$(size "$p")
    total=$((total + b))
    printf '  %s%10s%s  %s\n' "$(size_colour "$b")" "$(human "$b")" "$reset" "$p"
  done
  printf '  %s%10s%s  total\n' "$bold" "$(human "$total")" "$reset"

  heading "Also cleaned by 'clean' (not counted above)"
  note "journal:  $(journalctl --disk-usage | grep -o '[0-9.]*[MG]') -> vacuum to 200M"
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    note "docker:   prune stopped containers + dangling images (tagged images are kept; see 'docker system df')"
  fi
  if command -v flatpak >/dev/null 2>&1; then
    note "flatpak:  $(flatpak list --unused 2>/dev/null | tail -n +2 | wc -l) unused runtime(s)"
  fi
  if [ "$hard" = 1 ]; then
    note "docker:   --hard also removes every image no container uses (docker system prune -a)"
    note "nix:      --hard keeps only the current generation, gc's the store, refreshes the boot menu"
  else
    note "nix:      use 'nx clean' (old generations + store gc, needs sudo), or --hard here"
  fi

  heading "Big, but yours (never touched)"
  for p in "$share/Steam/steamapps/common" "$share/Steam/steamapps/compatdata" "$share/PrismLauncher" "$HOME/Pictures" "$HOME/Projects" "$HOME/Games" "/var/lib/flatpak"; do
    [ -d "$p" ] || continue
    b=$(size "$p")
    printf '  %s%10s%s  %s\n' "$(size_colour "$b")" "$(human "$b")" "$reset" "$p"
  done
  b=$(size /nix/store)
  printf '  %s%10s%s  /nix/store  %s(nx apps shows what in it is yours)%s\n' "$(size_colour "$b")" "$(human "$b")" "$reset" "$dim" "$reset"

  [ "$action" = clean ] || { echo; note "run 'nx storage clean' to delete the safe items above"; return 0; }

  if [ "$yes" != 1 ]; then
    echo
    read -r -p "Delete the caches above, vacuum the journal, prune docker and flatpak? [y/N] " arg
    [ "$arg" = y ] || { echo "aborted"; return 0; }
  fi
  step "Cleaning"

  local before after
  before=$(df --output=used -B1 / | tail -n 1)
  for p in "${paths[@]}"; do
    [ -d "$p" ] || continue
    find "$p" -mindepth 1 -delete 2>/dev/null || true
  done
  sudo journalctl --vacuum-size=200M >/dev/null || true
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    if [ "$hard" = 1 ]; then docker system prune -a -f >/dev/null || true; else docker system prune -f >/dev/null || true; fi
  fi
  if command -v flatpak >/dev/null 2>&1; then flatpak uninstall --unused --noninteractive >/dev/null 2>&1 || true; fi
  if [ "$hard" = 1 ]; then
    nh clean all --keep 1
    # drop the deleted generations from the boot menu without rebuilding anything
    sudo /run/current-system/bin/switch-to-configuration boot
  fi
  after=$(df --output=used -B1 / | tail -n 1)
  echo
  step "Freed about $(human $((before - after)))"
}
