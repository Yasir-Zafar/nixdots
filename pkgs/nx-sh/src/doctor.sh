doctor() {
  local issues=0 f n
  ok() { good "$*"; }
  warn() { caution "$*"; issues=$((issues + 1)); }

  step "Session"
  if [ -n "${NH_OS_FLAKE:-}" ] && [ -n "${NH_HOME_FLAKE:-}" ]; then ok "NH_OS_FLAKE / NH_HOME_FLAKE set"; else warn "NH_OS_FLAKE/NH_HOME_FLAKE not set: log out and in (nx always passes paths explicitly, so it is unaffected)"; fi
  if [ -e "$HOME/.config/home-manager/flake.nix" ]; then warn "stub flake at ~/.config/home-manager: a bare 'nh home switch' would use it instead of ~/dots/hm"; else ok "no stub home-manager flake"; fi

  if [ -r "$HOME/.config/sops/age/keys.txt" ]; then ok "sops age key present"; else warn "no sops age key at ~/.config/sops/age/keys.txt: secrets (git email) can't be decrypted; restore it from your backup"; fi

  step "System"
  if [ "$(readlink /run/booted-system/kernel)" != "$(readlink /run/current-system/kernel)" ] ||
    [ "$(readlink /run/booted-system/initrd)" != "$(readlink /run/current-system/initrd)" ]; then
    warn "reboot needed: running kernel/initrd differ from the current generation"
  else
    ok "booted kernel matches current generation"
  fi
  n=$(systemctl --failed --no-legend --plain 2>/dev/null | wc -l)
  if [ "$n" -gt 0 ]; then warn "$n failed system unit(s): systemctl --failed"; else ok "no failed system units"; fi
  n=$(systemctl --user --failed --no-legend --plain 2>/dev/null | wc -l)
  if [ "$n" -gt 0 ]; then warn "$n failed user unit(s): systemctl --user --failed"; else ok "no failed user units"; fi

  step "Leftovers"
  n=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    warn "core dump: $f ($(du -h --apparent-size "$f" | cut -f1) apparent)"
    n=$((n + 1))
  done < <(find "$HOME" "$dots" "$HOME/AppImages" -maxdepth 1 -name 'core.[0-9]*' -type f 2>/dev/null | sort -u)
  [ "$n" -eq 0 ] && ok "no stray core.* files"
  n=0
  while IFS= read -r f; do
    warn "backup file: $f"
    n=$((n + 1))
  done < <(find "$HOME" "$HOME/.config" "$HOME/.icons" "$HOME/.themes" "$HOME/.vscode" -maxdepth 2 -name '*.bak' 2>/dev/null | sort -u | head -20)
  [ "$n" -eq 0 ] && ok "no *.bak files from home-manager backups"

  step "Repo"
  if [ "$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' "$os/flake.lock")" = "$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' "$hm/flake.lock")" ]; then
    ok "nix/ and hm/ pin the same nixpkgs"
  else
    warn "nix/ and hm/ pin different nixpkgs revisions (nx update fixes it)"
  fi
  n=$(git -C "$dots" status --porcelain | wc -l)
  if [ "$n" -gt 0 ]; then warn "$n uncommitted change(s) in $dots"; else ok "repo is clean"; fi

  echo
  if [ "$issues" -eq 0 ]; then step "All good"; else printf '%s!%s %s%s thing(s) to look at%s\n' "$bold$yellow" "$reset" "$bold" "$issues" "$reset"; fi
}
