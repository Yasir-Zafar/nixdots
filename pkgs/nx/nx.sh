dots="${NX_DOTS:-$HOME/dots}"
os="$dots/nix"
hm="$dots/hm"
desktop="$dots/modules/nixos/desktop" # where the greeter import lives (nx try)
# every directory with nix files (for fmt; assets/ has none)
nixdirs=("$dots/nix" "$dots/hm" "$dots/hosts" "$dots/modules" "$dots/home" "$dots/pkgs" "$dots/lib")
# `nh … build` would otherwise drop a ./result link wherever nx runs;
# these links also keep the last build from being garbage-collected
links="${XDG_CACHE_HOME:-$HOME/.cache}/nx"
mkdir -p "$links"

# --- look: same as nh (green ">" for steps, bold headings), colours only on a terminal ---
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  bold=$'\e[1m' dim=$'\e[2m' reset=$'\e[0m'
  red=$'\e[31m' green=$'\e[32m' yellow=$'\e[33m' blue=$'\e[34m' cyan=$'\e[36m'
else
  bold='' dim='' reset='' red='' green='' yellow='' blue='' cyan=''
fi
step() { printf '%s>%s %s\n' "$bold$green" "$reset" "$*"; }
heading() { printf '\n%s%s%s\n' "$bold" "$*" "$reset"; }
note() { printf '  %s%s%s\n' "$dim" "$*" "$reset"; }
good() { printf '  %s✔%s %s\n' "$green" "$reset" "$*"; }
caution() { printf '  %s!%s %s\n' "$yellow" "$reset" "$*"; }
err() { printf '%serror:%s %s\n' "$bold$red" "$reset" "$*" >&2; }
# colour for a byte count: red from 1 GiB, yellow from 100 MiB
size_colour() {
  if [ "$1" -ge 1073741824 ]; then printf '%s' "$red"; elif [ "$1" -ge 104857600 ]; then printf '%s' "$yellow"; fi
}

usage() {
  # command names in bold cyan (plain when there are no colours)
  cat <<'USAGE' | sed -E "1s/.*/${bold}&${reset}/; s/^(  nx [a-z]+)/${bold}${cyan}\1${reset}/"
nx - nix update management

  nx update [input...]     update flake.lock in nix/ and hm/ (all inputs, or just those named)   [nfu]
  nx os [mode]             nixos-rebuild via nh: switch (default) | boot | test | build          [ns]
  nx home [mode] [-b]      home-manager via nh: switch (default) | build; -b backs up conflicts  [hs]
  nx all                   update, then os switch, then home switch
  nx build                 build os and home without activating (safe check)
  nx clean [nh args]       nh clean all, keeping 7 days / 5 generations by default              [ncg]
  nx optimise              nix store optimise                                                   [nso]
  nx diff                  package changes since boot (booted vs current system)
  nx status                lock ages, nixpkgs revs, uncommitted changes, disk space
  nx doctor                checks for the usual problems (env vars, stub flake, sops key, core dumps, backups, reboot needed)
  nx rollback [os|home]    list generations; `os [N]` / `home [N]` go back (previous one by default)
  nx try <greeter>         boot-test another greeter (tuigreet|lightdm|gdm|ly|sysc), see below
  nx firmware [action]     firmware via fwupd: check (default) | update | devices | history | bios
  nx apps [flags]          installed apps by the space only they use, in size classes (huge = IDEs, big apps)
                             flags: --all  also list the small ones
                                    --home | --system  only one side
  nx storage [report|clean] [flags]
                           report (default): what uses space and what is safe to delete (read-only)
                           clean: delete only regenerable caches after confirmation
                             flags: -y  skip the question
                                    --browsers       also browser caches (zen, chromium)
                                    --steam-shaders  also steam shader caches (games recompile them, brief stutter)
                                    --trash          also empty the trash
                                    --hard           all of the above, plus ~/.cache/nix (inputs are
                                                     re-downloaded), every docker image not in use, and
                                                     all old generations (no rollback left)
  nx lint                  statix + deadnix over the repo
  nx fmt                   alejandra over the repo
  nx help                  this text

nx try swaps the greeter import in modules/nixos/desktop/default.nix, builds, and (after you confirm)
runs `nh os boot`, then restores the file. It makes the variant the DEFAULT boot entry, but
it never touches the running session. Revert with `nx os boot` (or pick the old generation
in the boot menu). Greeters only appear after a reboot, so nothing is hot-swapped.
USAGE
}

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

update() {
  local flake
  for flake in "$os" "$hm"; do
    step "Updating $(basename "$flake")/flake.lock"
    if [ "$#" -eq 0 ]; then
      nix flake update --flake "$flake"
    else
      nix flake update "$@" --flake "$flake" || caution "skipped: not all of those inputs exist in $(basename "$flake")"
    fi
  done
  step "Done. Nothing changes until you build and switch (nx build, nx all)"
}

status() {
  local flake rev days col
  step "Flakes"
  for flake in "$os" "$hm"; do
    rev=$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev[0:8]' "$flake/flake.lock")
    days=$((($(date +%s) - $(stat -c %Y "$flake/flake.lock")) / 86400))
    col=$green
    if [ "$days" -ge 30 ]; then col=$red; elif [ "$days" -ge 7 ]; then col=$yellow; fi
    printf '  %s%-4s%s lock %s%s days old%s (%s)  nixpkgs %s%s%s\n' "$bold" "$(basename "$flake")" "$reset" "$col" "$days" "$reset" "$(date -r "$flake/flake.lock" '+%F %R')" "$bold" "$rev" "$reset"
  done
  heading "Git"
  git -C "$dots" status --short --branch | head -15 | sed 's/^/  /'
  heading "Disk"
  df -h / | awk -v y="$yellow" -v r="$red" -v z="$reset" 'NR==1{print "  " $0; next} {p=$5+0; c=(p>=90?r:(p>=75?y:"")); print "  " c $0 z}'
}

firmware() {
  local action="${1:-check}"
  case "$action" in
    check)
      step "Checking for firmware updates"
      fwupdmgr refresh --force || true
      # exit code 2 just means "nothing to update"
      fwupdmgr get-updates || true
      ;;
    update)
      step "Installing firmware updates"
      fwupdmgr update
      ;;
    devices)
      step "Firmware devices"
      fwupdmgr get-devices
      ;;
    history)
      step "Firmware history"
      fwupdmgr get-history
      ;;
    bios)
      step "BIOS"
      for f in sys_vendor product_name bios_vendor bios_version bios_date; do
        printf '  %s%-13s%s %s\n' "$bold" "$f" "$reset" "$(cat "/sys/class/dmi/id/$f" 2>/dev/null)"
      done
      ;;
    *) err "nx firmware: check|update|devices|history|bios"; exit 2 ;;
  esac
}

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

# Installed apps (programs in the home profile and the system profile) ranked by the space
# only they need: the size of everything in their closure that no other installed program
# also uses, so shared libraries don't count. Removing an app frees about that much.
apps() {
  local scope=all show_all=0 arg
  for arg in "$@"; do
    case "$arg" in
      -a | --all) show_all=1 ;;
      --home) scope=home ;;
      --system) scope=system ;;
      *) err "nx apps: unknown option '$arg' (--all|--home|--system)"; exit 2 ;;
    esac
  done

  local tmp
  tmp=$(mktemp -d)
  # expanded now: $tmp is local and gone by the time the trap runs
  # shellcheck disable=SC2064
  trap "rm -rf -- '$tmp'" EXIT

  step "Reading installed packages"
  local homeenv sysenv
  homeenv=$(readlink -f "$HOME/.local/state/nix/profiles/home-manager/home-path" 2>/dev/null || true)
  [ -e "$homeenv" ] || homeenv=$(readlink -f "$HOME/.nix-profile")
  sysenv=$(readlink -f /run/current-system/sw)

  # roots: "group path is-app origin"; outputs of one package (-bin, -man, ...) share a group
  local origin env p g isapp
  for origin in home system; do
    env=$homeenv
    [ "$origin" = system ] && env=$sysenv
    while IFS= read -r p; do
      g=$(basename "$p" | sed -E 's/^[a-z0-9]{32}-//; s/-(bin|man|doc|dev|info|lib|devdoc|out)$//; s/-[0-9]{12,}$//')
      isapp=0
      if [ -d "$p/bin" ] || [ -d "$p/share/applications" ]; then isapp=1; fi
      printf '%s %s %s %s\n' "$g" "$p" "$isapp" "$origin"
    done < <(nix-store -q --references "$env") >>"$tmp/roots"
  done

  step "Measuring closures"
  local -a paths
  mapfile -t paths < <(cut -d' ' -f2 "$tmp/roots")
  nix path-info -r --json --json-format 1 "${paths[@]}" |
    jq -r 'to_entries[] | "S \(.key) \(.value.narSize)", (.key as $k | .value.references[]? | select(. != $k) | "E \($k) \(.)")' >"$tmp/graph"

  # per group: closure size, and the part of it that no other group reaches
  awk '
    FNR == NR { if ($1 == "S") size[$2] = $3; else adj[$2] = adj[$2] " " $3; next }
    { rt[$1] = rt[$1] " " $2; if ($3 == 1) app[$1] = 1; if (index(org[$1], $4) == 0) org[$1] = org[$1] $4 ","
      if (!($1 in seen)) { seen[$1] = 1; groups[++ng] = $1 } }
    END {
      for (i = 1; i <= ng; i++) {
        g = groups[i]; delete vis; top = split(rt[g], st, " "); clos = 0
        while (top > 0) {
          p = st[top--]; if (p in vis) continue
          vis[p] = 1; clos += size[p]; cnt[p]++; owner[p] = g
          m = split(adj[p], a, " "); for (j = 1; j <= m; j++) if (!(a[j] in vis)) st[++top] = a[j]
        }
        closure[g] = clos
      }
      for (p in cnt) if (cnt[p] == 1) uniq[owner[p]] += size[p]
      for (i = 1; i <= ng; i++) { g = groups[i]; if (app[g]) printf "%d %d %s %s\n", uniq[g], closure[g], org[g], g }
    }' "$tmp/graph" "$tmp/roots" | sort -rn >"$tmp/apps"

  awk -v scope="$scope" -v all="$show_all" -v b="$bold" -v d="$dim" -v z="$reset" \
    -v red="$red" -v ylw="$yellow" -v blu="$blue" -v grn="$green" '
    function hum(x) {
      if (x >= 1073741824) return sprintf("%.1f GiB", x / 1073741824)
      if (x >= 1048576) return sprintf("%.0f MiB", x / 1048576)
      return sprintf("%.0f KiB", x / 1024)
    }
    BEGIN {
      lim[1] = 1073741824; name[1] = "Huge";   rng[1] = ">= 1 GiB";      col[1] = red   # IDEs, big suites
      lim[2] = 262144000;  name[2] = "Large";  rng[2] = "250 MiB - 1 GiB"; col[2] = ylw
      lim[3] = 52428800;   name[3] = "Medium"; rng[3] = "50 - 250 MiB";  col[3] = blu
      lim[4] = 0;          name[4] = "Small";  rng[4] = "< 50 MiB";      col[4] = grn
    }
    {
      u = $1; c = $2; o = $3; g = $4
      if (scope == "home" && o !~ /home/) next
      if (scope == "system" && o !~ /system/) next
      k = 4; for (i = 1; i <= 3; i++) if (u >= lim[i]) { k = i; break }
      n[k]++; tot[k] += u; all_u += u; all_n++
      sub(/,$/, "", o); gsub(/,/, "+", o)
      line[k, n[k]] = sprintf("  %s%10s%s  %-40s %-12s %sclosure %s%s", col[k], hum(u), z, g, o, d, hum(c), z)
    }
    END {
      for (k = 1; k <= 4; k++) {
        if (!n[k]) continue
        printf "\n%s%s%s%s  %s  %s·  %d app%s  ·  %s%s\n", b, col[k], name[k], z, rng[k], d, n[k], (n[k] == 1 ? "" : "s"), hum(tot[k]), z
        if (k == 4 && !all) { printf "  %s(--all lists them)%s\n", d, z; continue }
        for (i = 1; i <= n[k]; i++) print line[k, i]
      }
      printf "\n%s>%s %d apps, %s that only they use\n", b grn, z, all_n, hum(all_u)
      printf "  %ssize = space no other installed program needs (shared libraries are not counted).\n  closure = everything the app pulls in, shared or not. Remove an app in its module, then nx clean.%s\n", d, z
    }' "$tmp/apps"
}

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

cmd="${1:-help}"
shift || true

case "$cmd" in
  update | up) update "$@" ;;
  os) run_os "$@" ;;
  home) run_home "$@" ;;
  all)
    update
    run_os switch
    run_home switch
    ;;
  apps | app) apps "$@" ;;
  build)
    run_os build
    run_home build
    ;;
  clean | gc)
    if [ "$#" -eq 0 ]; then nh clean all --keep-since 7d --keep 5; else nh clean all "$@"; fi
    ;;
  optimise | optimize | opt)
    step "Optimising the store (hard-linking identical files)"
    nix store optimise
    ;;
  diff)
    step "Changes since boot (booted -> current system)"
    nvd diff /run/booted-system /run/current-system
    ;;
  status | st) status ;;
  storage | disk) storage "$@" ;;
  firmware | fw) firmware "$@" ;;
  doctor | dr) doctor ;;
  rollback | rb) rollback "$@" ;;
  try) try_greeter "$@" ;;
  lint)
    step "statix (anti-patterns)"
    if (cd "$dots" && statix check .); then good "nothing to fix"; else caution "statix found issues"; fi
    # hardware-configuration.nix is generated by nixos-generate-config
    step "deadnix (unused code)"
    if deadnix --fail --exclude "$dots/hosts/mntbnd/hardware-configuration.nix" "$dots"; then good "nothing unused"; else caution "deadnix found unused code"; fi
    ;;
  fmt)
    step "Formatting with alejandra"
    alejandra --quiet "${nixdirs[@]}" && good "done"
    ;;
  help | -h | --help) usage ;;
  *)
    err "nx: unknown command '$cmd'"
    usage >&2
    exit 2
    ;;
esac
