# nixos/services/networking.nix
{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      # DNS configuration
      dns = "systemd-resolved";
    };

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  # Enable systemd-resolved for DNS resolution
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=true
    '';
  };

  # Enable Network Time Protocol
  services.timesyncd.enable = true;
}
