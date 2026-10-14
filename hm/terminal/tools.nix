{
  config,
  pkgs,
  ...
}: {
  programs = {
    # user side of nh: NH_OS_FLAKE / NH_HOME_FLAKE. The gc timer lives in nix/nix.nix.
    nh = {
      enable = true;
      osFlake = "${config.home.homeDirectory}/dots/nix";
      homeFlake = "${config.home.homeDirectory}/dots/hm";
    };

    # `, cowsay hi` runs a package without installing it; typing a missing command
    # suggests the package that has it (database comes prebuilt from the flake input)
    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    # `tldr <cmd>`: short example-first man pages
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };

  home.packages = with pkgs; [
    # Modern core utilities
    fd
    ripgrep
    procs
    dust
    duf
    claude-code

    # File tools
    tree
    ncdu
    unzip
    p7zip
    unrar
    ouch # `extract` and `compress` use it

    # Docs
    glow # markdown in the terminal

    # Nix helpers
    nix-tree
    nix-output-monitor
    nvd

    # Dev utilities
    just
  ];
}
