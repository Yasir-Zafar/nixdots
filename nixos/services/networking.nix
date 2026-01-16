# nixos/services/networking.nix
{
  config,
  pkgs,
  ...
}: {
  # Network configuration
  networking = {
    hostName = "mntbnd"; # Replace with your desired hostname
    networkmanager = {
      enable = true;

      # Better battery life for laptops (disable if you have connection issues)
      wifi.powersave = true; # Change to false if you have WiFi performance issues
      dns = "systemd-resolved";

      # Additional user-friendly settings
      ethernet.macAddress = "preserve"; # Don't randomize MAC on Ethernet
      wifi.macAddress = "preserve"; # Don't randomize WiFi MAC (some networks need this)
    };

    # Enable wireless support via NetworkManager
    # wireless.enable = false; # Disabled in favor of NetworkManager

    firewall = {
      enable = true;
      allowPing = true; # Allows network troubleshooting

      # Minimal ports for average users (more secure)
      allowedTCPPorts = [
        8081 # Metro bundler
        19000 # Expo
        19001
        19002
        80
        443
      ];
      allowedUDPPorts = [53]; # DNS queries

      # Enable if you need these services:
      # allowedTCPPorts = [22 80 443]; # Add 22 for SSH if you're a developer
      # allowedTCPPorts = [80 443 8080]; # Add 8080 for development servers

      # Allow local network discovery (printers, media servers, etc.)
      trustedInterfaces = ["lo"]; # Loopback interface
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };

  services = {
    # Enhanced DNS resolution with privacy and performance
    resolved = {
      enable = true;

      # Security settings
      dnssec = "allow-downgrade"; # Enable DNSSEC but allow fallback

      # Privacy-focused DNS servers (faster than ISP DNS)
      fallbackDns = [
        "1.1.1.1" # Cloudflare (fast, privacy-focused)
        "1.0.0.1" # Cloudflare secondary
        "9.9.9.9" # Quad9 (security-focused, blocks malware)
        "8.8.8.8" # Google (fast, widely compatible)
      ];

      extraConfig = ''
        # Privacy: Encrypt DNS when possible
        DNSOverTLS=opportunistic

        # Local network discovery (find printers, etc.)
        MulticastDNS=true

        # Better caching for faster browsing
        Cache=yes
        CacheFromLocalhost=yes

        # Resolve local .local domains
        LLMNR=true
      '';
    };

    # Keep system time accurate (important for security certificates)
    timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com" # Cloudflare NTP (fast, reliable)
        "pool.ntp.org" # Global NTP pool
      ];
    };

    # Enable SSH daemon (optional)
    openssh = {
      enable = false; # Set to true if you need SSH
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  # Optional: Better network performance tuning
  boot.kernel.sysctl = {
    # Improve network performance
    "net.core.rmem_max" = 268435456;
    "net.core.wmem_max" = 268435456;
    "net.ipv4.tcp_rmem" = "4096 65536 268435456";
    "net.ipv4.tcp_wmem" = "4096 65536 268435456";

    # Better WiFi performance
    "net.ipv4.tcp_congestion_control" = "bbr"; # Modern congestion control
  };

  # Network tools
  environment.systemPackages = with pkgs; [
    wget
    curl
    nmap
    inetutils
  ];
}
