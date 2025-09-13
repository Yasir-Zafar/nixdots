# nixos/services/networking.nix
{
  config,
  pkgs,
  ...
}: {
  # Network configuration
  networking = {
    hostName = "mntbnd"; # Replace with your desired hostname
    networkmanager.enable = true;

    # Enable wireless support via NetworkManager
    wireless.enable = false; # Disabled in favor of NetworkManager
  };

  # DNS configuration
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  # Network tools
  environment.systemPackages = with pkgs; [
    wget
    curl
    nmap
  ];

  # Enable SSH daemon (optional)
  services.openssh = {
    enable = false; # Set to true if you need SSH
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
