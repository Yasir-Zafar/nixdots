{pkgs, ...}: {
  imports = [
    ./java.nix
    ./python.nix
    ./nix.nix
    ./c.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    pkg-config
    wireshark
  ];

  programs.wireshark.enable = true;
}
