# nixos/security/firewall.nix
{
  config,
  pkgs,
  ...
}: {
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Add ports you need open
      # 22 # SSH (if enabled)
    ];
    allowedUDPPorts = [
      # Add UDP ports you need
    ];
  };

  # Fail2ban for additional security (optional)
  services.fail2ban = {
    enable = false; # Set to true if you want intrusion prevention
    maxretry = 5;
  };
}
