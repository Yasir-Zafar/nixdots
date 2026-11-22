{
  inputs,
  my,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      # user profile in ~/.local/state/nix/profile, not ~/.nix-profile (home sets
      # nix.assumeXdg to match)
      use-xdg-base-directories = true;
      # dedupe happens weekly (nix.optimise below) instead of during every build

      # when free space drops under 5 GiB during a build, gc dead store paths until 20 GiB
      # are free (only garbage; generations are left to nh clean)
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # fewer downloads at once so big tarballs (IDEs etc.) don't split the bandwidth
      # 14 ways and all time out together. cores = 0 still lets each build use every core
      max-jobs = 4;
      max-substitution-jobs = 4;
      http-connections = 8;
      download-attempts = 10;
      # nix's default is 1 MiB, and its own docs say downloads stall when the buffer fills
      download-buffer-size = 64 * 1024 * 1024;
      # every command in ~/dots printed "Git tree is dirty"
      warn-dirty = false;
      stalled-download-timeout = 600;

      trusted-users = ["root" my.user];
      # noctalia; nix-community (the neovim nightly overlay's builds, so nvim isn't compiled
      # at every lock bump)
      extra-substituters = ["https://noctalia.cachix.org" "https://nix-community.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # builds (max-jobs 4, every core each) only get CPU and disk time nothing else wants,
    # so a big compile doesn't stutter the desktop or a game; they just finish later
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

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
