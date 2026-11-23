{lib, ...}: let
  # shell-agnostic aliases, split by topic
  aliases = lib.foldl' (a: f: a // import f) {} [
    ./common.nix
    ./git.nix
  ];

  # overrides for entries that are bash/zsh-specific
  fishOverrides = {
    # 'cd -' is not valid in fish; prevd is the equivalent
    # reload fish (not zsh)
    "reload" = "exec fish";

    # not `path`: that shadows a fish builtin
    "paths" = "string join \\n $PATH";

    # venv activate uses the fish-specific script
    "venv" = "source venv/bin/activate.fish";

    # mkvenv: a function in fish.nix
  };

  posixOverrides = {
    "-" = "cd -";
    "reload" = "exec zsh";
    "paths" = "echo -e \${PATH//:/\\n}";
    "venv" = "source venv/bin/activate";
    "mkvenv" = "python3 -m venv venv && source venv/bin/activate";
  };

  # aliases that shadow a real command: abbreviations in fish, so scripts get the real one
  shadowing = [
    "cp"
    "mv"
    "rm"
    "mkdir"
    "diff"
    "cat"
    "less"
    "grep"
    "find"
    "ps"
    "du"
    "df"
    "top"
  ];
  fishAll = aliases // fishOverrides;
in {
  programs = {
    zsh.shellAliases = aliases // posixOverrides;
    bash.shellAliases = aliases // posixOverrides;
    fish = {
      shellAliases = removeAttrs fishAll shadowing;
      shellAbbrs = lib.getAttrs shadowing fishAll;
    };
  };
}
