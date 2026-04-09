{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./c.nix
  ];

  environment.systemPackages = with pkgs; [
    wireshark
    ciscoPacketTracer8
  ];

  programs.wireshark.enable = true;
}
