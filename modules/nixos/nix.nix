{inputs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      # dedupe happens weekly (nix.optimise below) instead of during every build

      # when free space drops under 5 GiB during a build, gc dead store paths until 20 GiB
      # are free (only garbage; generations are left to nh clean)
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      trusted-users = ["root" "boi"];
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };

    # pin `nix shell nixpkgs#foo` and <nixpkgs> to the system's nixpkgs
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=flake:nixpkgs"];
    # no nix-channel: everything comes from the flakes, and nixPath above covers <nixpkgs>
    channel.enable = false;

    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  # cap the journal instead of vacuuming it by hand (it was ~390M)
  services.journald.settings.Journal.SystemMaxUse = "500M";

  # needs a channel database; nix-index (hm/terminal/tools.nix) does this job instead
  programs.command-not-found.enable = false;

  # system side of nh: the weekly gc timer (runs as root, so it also cleans home-manager
  # and user profiles). hm/terminal/tools.nix sets the flake paths for the user side.
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}
