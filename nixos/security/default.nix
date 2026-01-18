# nixos/security/default.nix
{
  imports = [
    ./firewall.nix
  ];

  # Security settings
  security.sudo.wheelNeedsPassword = false;

  # Polkit configuration
  security.polkit.enable = true;

  # AppArmor (optional security framework)
  security.apparmor.enable = false; # Set to true if you want extra security
}
