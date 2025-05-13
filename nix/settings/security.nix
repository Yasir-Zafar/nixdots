# settings/security.nix
{ pkgs, ... }:

{
  # Security settings
  security = {
    # Enable sudo and configure it
    sudo = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
      extraConfig = ''
        Defaults timestamp_timeout=300
        Defaults lecture=never
      '';
    };

    # Polkit for user permissions
    polkit.enable = true;

    # Firewall configuration
    # Note: Also see networking.nix for additional settings
    #firewall = {
    #  enable = true;
    #  allowPing = true;
    #  logReversePathDrops = true;
    #  checkReversePath = "loose";
    #  # Add more firewall settings as needed
    #};

    # Enable AppArmor
    apparmor = {
      enable = true;
      packages = with pkgs; [ apparmor-utils ];
    };

  };

  # Systemd hardening
  systemd = {
    extraConfig = ''
      DefaultTimeoutStartSec=30s
      DefaultTimeoutStopSec=10s
      DefaultRestartSec=100ms
    '';

    # Network sandboxing
    enableEmergencyMode = false;
  };
}
