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

  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    gnome-firmware
    theclicker
    appimage-run
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

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
