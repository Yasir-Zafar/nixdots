try_greeter() {
  local variant="${1:-}" file cfg="$desktop/default.nix" bak
  case "$variant" in
    tuigreet) file=tuigreet.nix ;;
    ldm | lightdm) file=lightdm.nix ;;
    g | gdm) file=gdm.nix ;;
    l | ly) file=ly.nix ;;
    sysc | default | sysc-greet) file=sysc-greet.nix ;;
    *) err "nx try: choose tuigreet|lightdm|gdm|ly|sysc"; exit 2 ;;
  esac
  [ -e "$desktop/greeters/$file" ] || { err "nx try: $desktop/greeters/$file not found"; exit 1; }

  bak=$(mktemp)
  cp "$cfg" "$bak"
  # always put desktop/default.nix back, whatever happens below
  trap 'cp "$bak" "$cfg"; rm -f "$bak"; git -C "$dots" add -N "$cfg" 2>/dev/null || true' EXIT

  sed -i "s#\./greeters/sysc-greet\.nix#./greeters/$file#" "$cfg"
  grep -q "greeters/$file" "$cfg" || { err "nx try: could not find the greeter import in $cfg"; exit 1; }
  step "Building $variant (nothing is activated yet)"
  nh os build "$os" -o "$links/os"

  read -r -p "Make '$variant' the default boot entry (reboot to try it)? [y/N] " answer
  [ "$answer" = y ] || { step "Aborted, desktop/default.nix restored"; exit 0; }
  nh os boot "$os"
  echo
  step "Reboot to see $variant. To go back: nx os boot  (or choose the previous generation in the boot menu)."
}
