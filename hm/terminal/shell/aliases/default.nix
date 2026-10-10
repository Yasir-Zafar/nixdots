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

    # fish PATH is a list; just print it
    "path" = "string join \\n $PATH";

    # venv activate uses the fish-specific script
    "venv" = "source venv/bin/activate.fish";

    # mkvenv: && is not fish syntax; defined as a function in fish.nix instead
    # (omitted here so it doesn't land as a broken alias)
  };

  posixOverrides = {
    "-" = "cd -";
    "reload" = "exec zsh";
    "path" = "echo -e \${PATH//:/\\n}";
    "venv" = "source venv/bin/activate";
    "mkvenv" = "python3 -m venv venv && source venv/bin/activate";
  };
in {
  programs = {
    zsh.shellAliases = aliases // posixOverrides;
    bash.shellAliases = aliases // posixOverrides;
    fish.shellAliases = aliases // fishOverrides;
  };
}
