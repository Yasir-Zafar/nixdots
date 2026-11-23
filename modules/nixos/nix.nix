{
  inputs,
  my,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      # profile under ~/.local/state/nix (home: nix.assumeXdg)
      use-xdg-base-directories = true;
      # dedupe happens weekly (nix.optimise below) instead of during every build

      # gc dead paths when a build leaves < 5 GiB free, up to 20 GiB
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # fewer parallel downloads so big tarballs don't all time out
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
      # noctalia; nix-community (nvim nightly isn't compiled every bump)
      extra-substituters = ["https://noctalia.cachix.org" "https://nix-community.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # builds get idle CPU/IO only, so they don't stutter the desktop or games
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

  # nh's weekly gc timer (root, so home profiles too); user side: terminal/tools.nix
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}
