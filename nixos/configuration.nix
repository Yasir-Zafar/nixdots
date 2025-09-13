{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware
    ./boot
    ./desktop
  ];

  networking.hostName = "mnt_bnd"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Kararchi";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.boi = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
    statix
    python313Packages.flake8
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05"; # Did you read the comment?
}
