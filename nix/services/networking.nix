{pkgs, ...}: {
  networking = {
    hostName = "mntbnd";

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      wifi = {
        powersave = true;
        macAddress = "preserve";
      };

      ethernet.macAddress = "preserve";
    };

    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = ["lo"];

      allowedTCPPorts = [
        8081
        19000
        19001
        19002
        80
        443
      ];

      allowedUDPPorts = [
        7777
        53
      ];

      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        DNSOverTLS = "opportunistic";
        MulticastDNS = true;
        LLMNR = true;
        Cache = true;
        CacheFromLocalhost = true;
        DNSSEC = "allow-downgrade";

        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
          "9.9.9.9"
          "8.8.8.8"
        ];
      };
    };
  };

  services.timesyncd = {
    enable = true;
    servers = [
      "time.cloudflare.com"
      "pool.ntp.org"
    ];
  };

  services.openssh = {
    enable = false;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 268435456;
    "net.core.wmem_max" = 268435456;
    "net.ipv4.tcp_rmem" = "4096 65536 268435456";
    "net.ipv4.tcp_wmem" = "4096 65536 268435456";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    nmap
    inetutils
  ];
}
