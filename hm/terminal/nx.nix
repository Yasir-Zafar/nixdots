# nx: one command for update management, replaces the ns/hs/nfu/... aliases.
#   nx <command> [option]   see `nx help`
# It always passes ~/dots/nix and ~/dots/hm explicitly, so it does not depend on
# NH_OS_FLAKE / NH_HOME_FLAKE being set in the current session.
{pkgs, ...}: let
  nx = pkgs.writeShellApplication {
    name = "nx";

    runtimeInputs = with pkgs; [nh nix nvd jq git statix deadnix alejandra coreutils findutils gnugrep gawk gnused home-manager fwupd];

    text = ''
      dots="''${NX_DOTS:-$HOME/dots}"
      os="$dots/nix"
      hm="$dots/hm"

      usage() {
        cat <<'USAGE'
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
        nx doctor                checks for the usual problems (env vars, stub flake, core dumps, backups, reboot needed)
        nx rollback [os|home]    list generations; `os [N]` / `home [N]` go back (previous one by default)
        nx try <greeter>         boot-test another desktop/greeter variant (tuigreet|ldm|g|l|sysc), see below
        nx firmware [action]     firmware via fwupd: check (default) | update | devices | history | bios
        nx lint                  statix + deadnix over the repo
        nx fmt                   alejandra over the repo
        nx help                  this text

      nx try swaps the ./desktop import in nix/configuration.nix, builds, and (after you confirm)
      runs `nh os boot`, then restores the file. It makes the variant the DEFAULT boot entry, but
      it never touches the running session. Revert with `nx os boot` (or pick the old generation
      in the boot menu). Greeters only appear after a reboot, so nothing is hot-swapped.
      USAGE
      }

      run_os() {
        local mode="''${1:-switch}"
        shift || true
        case "$mode" in
          switch | boot | test | build) nh os "$mode" "$os" "$@" ;;
          *) echo "nx os: unknown mode '$mode' (switch|boot|test|build)" >&2; exit 2 ;;
        esac
      }

      run_home() {
        local mode="switch" backup=0 arg
        for arg in "$@"; do
          case "$arg" in
            switch | build) mode="$arg" ;;
            -b | --backup) backup=1 ;;
            *) echo "nx home: unknown option '$arg' (switch|build|-b)" >&2; exit 2 ;;
          esac
        done
        if [ "$backup" = 1 ]; then
          HOME_MANAGER_BACKUP_EXT=bak nh home "$mode" "$hm"
        else
          nh home "$mode" "$hm"
        fi
      }

      update() {
        local flake
        for flake in "$os" "$hm"; do
          echo ":: updating $flake"
          if [ "$#" -eq 0 ]; then
            nix flake update --flake "$flake"
          else
            nix flake update "$@" --flake "$flake" || echo "   (skipped: not all of those inputs exist here)"
          fi
        done
      }

      status() {
        local flake rev
        for flake in "$os" "$hm"; do
          rev=$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev[0:8]' "$flake/flake.lock")
          echo ":: $(basename "$flake")  lock changed $(date -r "$flake/flake.lock" '+%F %R')  nixpkgs $rev"
        done
        echo
        echo ":: git"
        git -C "$dots" status --short --branch | head -15
        echo
        echo ":: disk"
        df -h /
      }

      firmware() {
        local action="''${1:-check}"
        case "$action" in
          check)
            fwupdmgr refresh --force || true
            # exit code 2 just means "nothing to update"
            fwupdmgr get-updates || true
            ;;
          update) fwupdmgr update ;;
          devices) fwupdmgr get-devices ;;
          history) fwupdmgr get-history ;;
          bios)
            for f in sys_vendor product_name bios_vendor bios_version bios_date; do
              printf '%-13s %s\n' "$f" "$(cat "/sys/class/dmi/id/$f" 2>/dev/null)"
            done
            ;;
          *) echo "nx firmware: check|update|devices|history|bios" >&2; exit 2 ;;
        esac
      }

      doctor() {
        local issues=0 f n
        ok() { echo "  ok    $*"; }
        warn() { echo "  WARN  $*"; issues=$((issues + 1)); }

        echo ":: session"
        if [ -n "''${NH_OS_FLAKE:-}" ] && [ -n "''${NH_HOME_FLAKE:-}" ]; then ok "NH_OS_FLAKE / NH_HOME_FLAKE set"; else warn "NH_OS_FLAKE/NH_HOME_FLAKE not set: log out and in (nx always passes paths explicitly, so it is unaffected)"; fi
        if [ -e "$HOME/.config/home-manager/flake.nix" ]; then warn "stub flake at ~/.config/home-manager: a bare 'nh home switch' would use it instead of ~/dots/hm"; else ok "no stub home-manager flake"; fi

        echo ":: system"
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

        echo ":: leftovers"
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
        done < <(find "$HOME" "$HOME/.config" "$HOME/.icons" "$HOME/.themes" -maxdepth 2 -name '*.bak' 2>/dev/null | sort -u | head -20)
        [ "$n" -eq 0 ] && ok "no *.bak files from home-manager backups"

        echo ":: repo"
        if [ "$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' "$os/flake.lock")" = "$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' "$hm/flake.lock")" ]; then
          ok "nix/ and hm/ pin the same nixpkgs"
        else
          warn "nix/ and hm/ pin different nixpkgs revisions (nx update fixes it)"
        fi
        n=$(git -C "$dots" status --porcelain | wc -l)
        if [ "$n" -gt 0 ]; then warn "$n uncommitted change(s) in $dots"; else ok "repo is clean"; fi

        echo
        if [ "$issues" -eq 0 ]; then echo "all good"; else echo "$issues thing(s) to look at"; fi
      }

      rollback() {
        local target="''${1:-}" gen="''${2:-}" line path
        case "$target" in
          "")
            echo ":: nixos generations (newest last)"
            find /nix/var/nix/profiles -maxdepth 1 -name 'system-*-link' -printf '%T+ %f\n' | sort | tail -8
            echo
            echo ":: home-manager generations"
            home-manager generations | head -8
            echo
            echo "nx rollback os [N] | nx rollback home [N]"
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
            [ -n "$line" ] || { echo "nx rollback home: no such generation" >&2; exit 1; }
            path=$(echo "$line" | awk '{print $NF}')
            [ "$path" = "(current)" ] && path=$(echo "$line" | awk '{print $(NF-1)}')
            echo "activating: $line"
            "$path/activate"
            ;;
          *) echo "nx rollback: expected os|home" >&2; exit 2 ;;
        esac
      }

      try_greeter() {
        local variant="''${1:-}" file cfg="$os/configuration.nix" bak
        case "$variant" in
          tuigreet) file=default-tuigreet.nix ;;
          ldm | lightdm) file=default-ldm.nix ;;
          g | gdm) file=default-g.nix ;;
          l | ly) file=default-l.nix ;;
          sysc | default | sysc-greet) file="" ;;
          *) echo "nx try: choose tuigreet|ldm|g|l|sysc" >&2; exit 2 ;;
        esac
        [ -z "$file" ] || [ -e "$os/desktop/$file" ] || { echo "nx try: $os/desktop/$file not found" >&2; exit 1; }

        bak=$(mktemp)
        cp "$cfg" "$bak"
        # always put configuration.nix back, whatever happens below
        trap 'cp "$bak" "$cfg"; rm -f "$bak"; git -C "$dots" add -N "$cfg" 2>/dev/null || true' EXIT

        if [ -n "$file" ]; then
          sed -i "s#\./desktop\([^a-z-]\|$\)#./desktop/$file\1#" "$cfg"
          grep -q "desktop/$file" "$cfg" || { echo "nx try: could not find the ./desktop import in $cfg" >&2; exit 1; }
        fi
        echo ":: building $variant (nothing is activated yet)"
        nh os build "$os"

        read -r -p "Make '$variant' the default boot entry (reboot to try it)? [y/N] " answer
        [ "$answer" = y ] || { echo "aborted, configuration.nix restored"; exit 0; }
        nh os boot "$os"
        echo
        echo "Reboot to see $variant. To go back: nx os boot  (or choose the previous generation in the boot menu)."
      }

      cmd="''${1:-help}"
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
        build)
          run_os build
          run_home build
          ;;
        clean | gc)
          if [ "$#" -eq 0 ]; then nh clean all --keep-since 7d --keep 5; else nh clean all "$@"; fi
          ;;
        optimise | optimize | opt) nix store optimise ;;
        diff) nvd diff /run/booted-system /run/current-system ;;
        status | st) status ;;
        firmware | fw) firmware "$@" ;;
        doctor | dr) doctor ;;
        rollback | rb) rollback "$@" ;;
        try) try_greeter "$@" ;;
        lint)
          statix check "$dots" || true
          deadnix "$dots" || true
          ;;
        fmt) alejandra --quiet "$os" "$hm" "$dots/dotfiles" ;;
        help | -h | --help) usage ;;
        *)
          echo "nx: unknown command '$cmd'" >&2
          usage >&2
          exit 2
          ;;
      esac
    '';
  };

  commands = "update os home all build clean optimise diff status firmware doctor rollback try lint fmt help";

  fishCompletions = pkgs.writeTextDir "share/fish/vendor_completions.d/nx.fish" ''
    complete -c nx -f
    complete -c nx -n __fish_use_subcommand -a "${commands}"
    complete -c nx -n "__fish_seen_subcommand_from os" -a "switch boot test build"
    complete -c nx -n "__fish_seen_subcommand_from home" -a "switch build -b"
    complete -c nx -n "__fish_seen_subcommand_from firmware" -a "check update devices history bios"
    complete -c nx -n "__fish_seen_subcommand_from rollback" -a "os home"
    complete -c nx -n "__fish_seen_subcommand_from try" -a "tuigreet ldm g l sysc"
    complete -c nx -n "__fish_seen_subcommand_from update" -a "nixpkgs home-manager niri noctalia nixcord nixvim stylix zen-browser"
  '';

  zshCompletions = pkgs.writeTextDir "share/zsh/site-functions/_nx" ''
    #compdef nx
    local -a cmds=(${commands})
    if (( CURRENT == 2 )); then
      _describe 'command' cmds
    elif [[ $words[2] == os ]]; then
      _values 'mode' switch boot test build
    elif [[ $words[2] == home ]]; then
      _values 'mode' switch build -b
    elif [[ $words[2] == firmware ]]; then
      _values 'action' check update devices history bios
    elif [[ $words[2] == rollback ]]; then
      _values 'target' os home
    elif [[ $words[2] == try ]]; then
      _values 'greeter' tuigreet ldm g l sysc
    fi
  '';
in {
  home.packages = [nx fishCompletions zshCompletions];
}
