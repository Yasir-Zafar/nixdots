# nixos/services/ssh.nix
{ pkgs, ... }:

{
  # Enable OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = true;
      KbdInteractiveAuthentication = false;
    };
  };

  # Install SSH-related packages
  environment.systemPackages = with pkgs; [
    openssh
  ];
}
