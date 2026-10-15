# nx completions (fish). Flake inputs for `nx update` are read from both lock files, so new
# inputs complete without editing this. @jq@ is replaced at build time.
set -l cmds update os home all build clean optimise diff status apps storage firmware doctor rollback try loc lint fmt tui help
complete -c nx -f
complete -c nx -n __fish_use_subcommand -a "$cmds"
complete -c nx -n "__fish_seen_subcommand_from os" -a "switch boot test build"
complete -c nx -n "__fish_seen_subcommand_from home" -a "switch build -b"
complete -c nx -n "__fish_seen_subcommand_from apps" -a "--all --home --system"
complete -c nx -n "__fish_seen_subcommand_from storage" -a "report clean -y --browsers --steam-shaders --trash --hard"
complete -c nx -n "__fish_seen_subcommand_from firmware" -a "check update devices history bios"
complete -c nx -n "__fish_seen_subcommand_from rollback" -a "os home"
complete -c nx -n "__fish_seen_subcommand_from try" -a "tuigreet lightdm gdm ly sysc"
complete -c nx -n "__fish_seen_subcommand_from update" -a "(@jq@ -r '.nodes.root.inputs | keys[]' ~/dots/nix/flake.lock ~/dots/hm/flake.lock 2>/dev/null | sort -u)"
