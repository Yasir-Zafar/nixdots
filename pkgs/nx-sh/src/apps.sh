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
