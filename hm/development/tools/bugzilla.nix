{
  config,
  pkgs,
  ...
}: {
  # Enable Apache HTTP Server
  services.httpd = {
    enable = true;
    adminAddr = "admin@localhost";

    # Enable Perl CGI support
    enablePerl = true;

    # Virtual hosts configuration
    virtualHosts."localhost" = {
      documentRoot = "/var/www";
      extraConfig = ''
        <Directory "/var/www">
          Options Indexes FollowSymLinks ExecCGI
          AllowOverride All
          Require all granted
          AddHandler cgi-script .cgi .pl
        </Directory>
      '';
    };
  };

  # Enable MySQL (MariaDB)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # Ensure the database initializes on first run
    ensureDatabases = ["testdb"];

    # Create a default user (optional)
    ensureUsers = [
      {
        name = "admin";
        ensurePermissions = {
          "testdb.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Install Perl and common modules
  environment.systemPackages = with pkgs; [
    perl
    perlPackages.DBI
    perlPackages.DBDmysql
    perlPackages.CGI
    perlPackages.JSON
    mysql
  ];

  # Open firewall for HTTP
  networking.firewall.allowedTCPPorts = [80];

  # Create web root directory
  systemd.tmpfiles.rules = [
    "d /var/www 0755 wwwrun wwwrun -"
  ];
}
