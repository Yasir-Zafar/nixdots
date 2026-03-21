{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./c.nix
  ];

  environment.systemPackages = with pkgs; [
    wireshark
  ];

  programs.wireshark.enable = true;
}
