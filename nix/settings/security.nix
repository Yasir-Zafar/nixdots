# settings/security.nix
{ config, lib, pkgs, ... }:

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
              options = [ "NOPASSWD" ]; # Allow passwordless sudo
            }
          ];
        }
      ];
      extraConfig = ''
        Defaults timestamp_timeout=300
        Defaults lecture=never
      '';
    };
    
    # RTKit for better desktop performance
    rtkit.enable = true;
    
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
  
  # Limit process resource usage
  # services.cgrulesengd = {
  #   enable = true;
  #   settings = {
  #     "*/chrome" = {
  #       memory = { limit = 4096; };
  #     };
  #   };
  # };
  
  # Install security tools
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
    keepassxc
    cryptsetup
    openssl
    libfido2
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    age
    rage
    sops
    bitwarden-cli
    pass
  ];
  
  # Enable fwupd for firmware updates
  services.fwupd.enable = true;
}
