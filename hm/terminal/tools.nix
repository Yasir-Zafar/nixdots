{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    osFlake = "${config.home.homeDirectory}/dots/nix";
    homeFlake = "${config.home.homeDirectory}/dots/hm";
  };

  # `tldr <cmd>`: short example-first man pages
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
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
