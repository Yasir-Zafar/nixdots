{pkgs, ...}: {
  imports = [
    ./hardware
    ./boot
    ./desktop
    ./gaming
    ./development
    ./users
    ./security
    ./services
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.10"
  ];

  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [pkgs.libxshmfence];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
