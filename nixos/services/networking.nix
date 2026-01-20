# nixos/services/networking.nix
# Network configuration with NetworkManager and enhanced DNS
{pkgs, ...}: {
  # ============================================================================
  # Network Configuration
  # ============================================================================
  networking = {
    hostName = "mntbnd";

    # -------------------------------------------------------------------------
    # NetworkManager
    # -------------------------------------------------------------------------
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      # WiFi settings
      wifi = {
        powersave = true; # Better battery life (disable if WiFi is slow)
        macAddress = "preserve"; # Don't randomize MAC (some networks require this)
      };

      # Ethernet settings
      ethernet.macAddress = "preserve"; # Preserve Ethernet MAC address
    };

    # -------------------------------------------------------------------------
    # Firewall Configuration
    # -------------------------------------------------------------------------
    firewall = {
      enable = true;
      allowPing = true; # Allow ICMP for network diagnostics

      # Loopback interface is always trusted
      trustedInterfaces = ["lo"];

      # TCP ports
      allowedTCPPorts = [
        # Development servers
        8081 # React Native Metro bundler
        19000 # Expo
        19001 # Expo DevTools
        19002 # Expo tunnel

        # Web services
        80 # HTTP
        443 # HTTPS

        # Add these if needed:
        # 22                                            # SSH
        # 3000                                          # Common dev server
        # 8080                                          # Alternative HTTP
      ];

      # UDP ports
      allowedUDPPorts = [
        53 # DNS queries
      ];

      # Port ranges for specific services
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

  # ============================================================================
  # DNS Configuration (systemd-resolved)
  # ============================================================================
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        # DNS over TLS for privacy
        DNSOverTLS = "opportunistic";

        # Local network service discovery
        MulticastDNS = true;
        LLMNR = true;

        # DNS caching for faster browsing
        Cache = true;
        CacheFromLocalhost = true;

        # DNSSEC validation
        DNSSEC = "allow-downgrade"; # Enable DNSSEC but allow fallback

        # Privacy-focused DNS servers (faster and more private than ISP DNS)
        FallbackDNS = [
          "1.1.1.1" # Cloudflare (privacy-focused, fast)
          "1.0.0.1" # Cloudflare secondary
          "9.9.9.9" # Quad9 (blocks malware/phishing)
          "8.8.8.8" # Google (widely compatible)
        ];

        # Optional: Randomize DNS queries for privacy
        # RandomizeStub=yes
      };
    };
  };

  # ============================================================================
  # Time Synchronization (NTP)
  # ============================================================================
  services.timesyncd = {
    enable = true;
    servers = [
      "time.cloudflare.com" # Cloudflare NTP (fast, reliable)
      "pool.ntp.org" # Global NTP pool
    ];
  };

  # ============================================================================
  # SSH Server (Optional)
  # ============================================================================
  services.openssh = {
    enable = false; # Enable if you need remote access

    # Security settings (if enabled)
    settings = {
      PasswordAuthentication = false; # Only allow key-based auth
      KbdInteractiveAuthentication = false; # Disable keyboard-interactive auth
      PermitRootLogin = "no"; # Never allow root login

      # Optional: Change default port
      # Port = 2222;
    };

    # Optional: Restrict to specific interfaces
    # listenAddresses = [
    #   { addr = "192.168.1.100"; port = 22; }
    # ];
  };

  # ============================================================================
  # Network Performance Tuning
  # ============================================================================
  boot.kernel.sysctl = {
    # TCP/IP stack optimizations
    "net.core.rmem_max" = 268435456; # Max receive buffer size
    "net.core.wmem_max" = 268435456; # Max send buffer size
    "net.ipv4.tcp_rmem" = "4096 65536 268435456"; # TCP receive buffer sizes
    "net.ipv4.tcp_wmem" = "4096 65536 268435456"; # TCP send buffer sizes

    # Modern congestion control algorithm (better performance)
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Optional: Additional performance tuning
    # "net.ipv4.tcp_fastopen" = 3;                      # Enable TCP Fast Open
    # "net.core.netdev_max_backlog" = 16384;            # Increase packet queue
    # "net.ipv4.tcp_max_syn_backlog" = 8192;            # Increase SYN backlog
  };

  # ============================================================================
  # Network Utilities
  # ============================================================================
  environment.systemPackages = with pkgs; [
    wget # File downloader
    curl # HTTP client
    nmap # Network scanner
    inetutils # Network tools (ping, traceroute, etc.)

    # Additional tools to consider:
    # dig                                               # DNS lookup
    # whois                                             # Domain information
    # mtr                                               # Network diagnostics (ping + traceroute)
    # iperf                                             # Network performance testing
    # wireguard-tools                                   # VPN tools
  ];
}
