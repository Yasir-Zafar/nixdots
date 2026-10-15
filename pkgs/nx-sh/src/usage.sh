usage() {
  # command names in bold cyan (plain when there are no colours)
  cat <<'USAGE' | sed -E "1s/.*/${bold}&${reset}/; s/^(  nx [a-z]+)/${bold}${cyan}\1${reset}/"
nx - nix update management

  nx update [input...]     update flake.lock in nix/ and hm/ (all inputs, or just those named)   [nfu]
  nx os [mode]             nixos-rebuild via nh: switch (default) | boot | test | build          [ns]
  nx home [mode] [-b]      home-manager via nh: switch (default) | build; -b backs up conflicts  [hs]
  nx all                   update, then os switch, then home switch
  nx build                 build os and home without activating (safe check)
  nx clean [nh args]       nh clean all, keeping the newest 4 generations by default             [ncg]
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
