# nx (bash version): one command for update management, replaces the ns/hs/nfu/... aliases.
#   nx <command> [option]   see `nx help`
# It always passes ~/dots/nix and ~/dots/hm explicitly, so it does not depend on
# NH_OS_FLAKE / NH_HOME_FLAKE being set in the current session.
# Returns [nx fish-completions zsh-completions]; installed by modules/home/terminal/nx.nix.
{pkgs}: let
  nx = pkgs.writeShellApplication {
    name = "nx";

    runtimeInputs = with pkgs; [nh nix nvd jq git statix deadnix alejandra coreutils findutils gnugrep gawk gnused home-manager fwupd procps];

    # plain bash in ./src, one file per command, joined in this order (lib first, the
    # dispatcher last); shellcheck runs on the result at build time
    text = pkgs.lib.concatMapStringsSep "\n" (f: builtins.readFile (./src + "/${f}")) [
      "lib.sh"
      "usage.sh"
      "rebuild.sh"
      "update.sh"
      "status.sh"
      "firmware.sh"
      "storage.sh"
      "apps.sh"
      "doctor.sh"
      "rollback.sh"
      "try.sh"
      "main.sh"
    ];
  };

  commands = "update os home all build clean optimise diff status apps storage firmware doctor rollback try lint fmt help";

  fishCompletions = pkgs.writeTextDir "share/fish/vendor_completions.d/nx.fish" ''
    complete -c nx -f
    complete -c nx -n __fish_use_subcommand -a "${commands}"
    complete -c nx -n "__fish_seen_subcommand_from os" -a "switch boot test build"
    complete -c nx -n "__fish_seen_subcommand_from home" -a "switch build -b"
    complete -c nx -n "__fish_seen_subcommand_from apps" -a "--all --home --system"
    complete -c nx -n "__fish_seen_subcommand_from storage" -a "report clean -y --browsers --steam-shaders --trash --hard"
    complete -c nx -n "__fish_seen_subcommand_from firmware" -a "check update devices history bios"
    complete -c nx -n "__fish_seen_subcommand_from rollback" -a "os home"
    complete -c nx -n "__fish_seen_subcommand_from try" -a "tuigreet lightdm gdm ly sysc"
    # inputs are read from both lock files, so new flake inputs complete without editing this
    complete -c nx -n "__fish_seen_subcommand_from update" -a "(${pkgs.jq}/bin/jq -r '.nodes.root.inputs | keys[]' ~/dots/nix/flake.lock ~/dots/hm/flake.lock 2>/dev/null | sort -u)"
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
    elif [[ $words[2] == apps ]]; then
      _values 'option' --all --home --system
    elif [[ $words[2] == storage ]]; then
      _values 'option' report clean -y --browsers --steam-shaders --trash --hard
    elif [[ $words[2] == firmware ]]; then
      _values 'action' check update devices history bios
    elif [[ $words[2] == rollback ]]; then
      _values 'target' os home
    elif [[ $words[2] == try ]]; then
      _values 'greeter' tuigreet lightdm gdm ly sysc
    elif [[ $words[2] == update ]]; then
      local -a inputs=(''${(f)"$(${pkgs.jq}/bin/jq -r '.nodes.root.inputs | keys[]' ~/dots/nix/flake.lock ~/dots/hm/flake.lock 2>/dev/null | sort -u)"})
      _describe 'input' inputs
    fi
  '';
in [nx fishCompletions zshCompletions]
