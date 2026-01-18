# nixos/security/firewall.nix
# Network firewall and intrusion prevention configuration
{
  # ============================================================================
  # Firewall Configuration
  # ============================================================================
  networking.firewall = {
    enable = true;

    # -------------------------------------------------------------------------
    # Allowed Ports
    # -------------------------------------------------------------------------
    allowedTCPPorts = [
      # SSH (if enabled)
      # 22

      # Common services:
      # 80                                              # HTTP
      # 443                                             # HTTPS
      # 3000                                            # Development servers
      # 8080                                            # Alternative HTTP

      # Game servers (examples):
      # 25565                                           # Minecraft
      # 27015                                           # Source games
    ];

    allowedUDPPorts = [
      # Game-related ports:
      # 27015                                           # Source games (UDP)
      # 3478                                            # Steam voice chat
      # 4380                                            # Steam client

      # Syncthing (if used):
      # 22000                                           # Syncthing transfers
      # 21027                                           # Syncthing discovery
    ];

    # -------------------------------------------------------------------------
    # Port Ranges
    # -------------------------------------------------------------------------
    # allowedTCPPortRanges = [
    #   { from = 1714; to = 1764; }                     # KDE Connect
    # ];
    # allowedUDPPortRanges = [
    #   { from = 1714; to = 1764; }                     # KDE Connect
    # ];

    # -------------------------------------------------------------------------
    # Additional Options
    # -------------------------------------------------------------------------
    # Allow all traffic on local network (careful with this!)
    # trustedInterfaces = [ "lo" ];                     # Loopback interface

    # Allow ping (ICMP echo requests)
    allowPing = true;

    # Log refused connections (can be verbose)
    # logRefusedConnections = true;
    # logRefusedPackets = false;
  };

  # ============================================================================
  # Fail2Ban - Intrusion Prevention
  # ============================================================================
  # Monitors logs and bans IPs with suspicious activity
  services.fail2ban = {
    enable = false; # Set to true to enable

    # Maximum retry attempts before ban
    maxretry = 5;

    # Ban duration (in seconds)
    # bantime = "10m";                                  # Default: 10 minutes
    # bantime-increment.enable = true;                  # Increase ban time for repeat offenders

    # Configuration for specific jails
    # jails = {
    #   sshd = ''
    #     enabled = true
    #     port = 22
    #   '';
    # };

    # Ignore specific IPs (whitelist)
    # ignoreIP = [
    #   "127.0.0.1/8"
    #   "192.168.1.0/24"                                # Your local network
    # ];
  };

  # ============================================================================
  # Additional Network Security
  # ============================================================================
  # Uncomment for enhanced network security:

  # Kernel network hardening
  # boot.kernel.sysctl = {
  #   # IP forwarding (disable unless you're routing)
  #   "net.ipv4.ip_forward" = 0;
  #   "net.ipv6.conf.all.forwarding" = 0;
  #
  #   # SYN flood protection
  #   "net.ipv4.tcp_syncookies" = 1;
  #   "net.ipv4.tcp_syn_retries" = 5;
  #   "net.ipv4.tcp_synack_retries" = 2;
  #
  #   # Ignore ICMP redirects
  #   "net.ipv4.conf.all.accept_redirects" = 0;
  #   "net.ipv6.conf.all.accept_redirects" = 0;
  #
  #   # Ignore source-routed packets
  #   "net.ipv4.conf.all.accept_source_route" = 0;
  #   "net.ipv6.conf.all.accept_source_route" = 0;
  #
  #   # Reverse path filtering (prevent IP spoofing)
  #   "net.ipv4.conf.all.rp_filter" = 1;
  # };
}
