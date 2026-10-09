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

  home.packages = with pkgs; [
    # Modern core utilities
    fd
    ripgrep
    procs
    dust
    duf

    # File tools
    tree
    ncdu
    unzip
    p7zip
    unrar

    # Nix helpers
    nix-tree
    nix-output-monitor
    nvd

    # Dev utilities
    just
  ];
}
