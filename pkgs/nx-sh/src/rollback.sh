rollback() {
  local target="${1:-}" gen="${2:-}" line path
  case "$target" in
    "")
      step "NixOS generations (newest last)"
      find /nix/var/nix/profiles -maxdepth 1 -name 'system-*-link' -printf '%T+ %f\n' | sort | tail -8 | sed 's/^/  /'
      heading "Home-manager generations"
      home-manager generations | head -8 | sed 's/^/  /'
      echo
      note "nx rollback os [N] | nx rollback home [N]"
      ;;
    os)
      if [ -n "$gen" ]; then nh os rollback --to "$gen"; else nh os rollback; fi
      ;;
    home)
      if [ -n "$gen" ]; then
        line=$(home-manager generations | grep -E "id $gen ->" || true)
      else
        line=$(home-manager generations | sed -n 2p)
      fi
      [ -n "$line" ] || { err "nx rollback home: no such generation"; exit 1; }
      path=$(echo "$line" | awk '{print $NF}')
      [ "$path" = "(current)" ] && path=$(echo "$line" | awk '{print $(NF-1)}')
      step "Activating $line"
      "$path/activate"
      ;;
    *) err "nx rollback: expected os|home"; exit 2 ;;
  esac
}
