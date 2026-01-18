# nixos/services/bugzilla.nix
# Bugzilla bug tracking system with Apache and MySQL
{pkgs, ...}: {
  # ============================================================================
  # Apache Web Server Configuration
  # ============================================================================
  services.httpd = {
    enable = true;
    adminAddr = "you@example.com"; # TODO: Change to your email
    enablePHP = false; # Not needed for Perl-based Bugzilla

    # Required Apache modules for Bugzilla
    extraModules = [
      "cgi" # CGI support
      "cgid" # CGI daemon for better performance
      "perl" # mod_perl for Perl scripts
    ];

    # Virtual host configuration
    virtualHosts."localhost" = {
      documentRoot = "/home/boi/Projects/Sem5/SQE/bugzilla";

      extraConfig = ''
        <Directory "/home/boi/Projects/Sem5/SQE/bugzilla">
          Options +ExecCGI +FollowSymLinks
          AddHandler cgi-script .cgi .pl
          DirectoryIndex index.cgi
          AllowOverride All
          Require all granted
        </Directory>

        # mod_perl configuration for better performance
        <IfModule mod_perl.c>
          <Directory "/home/boi/Projects/Sem5/SQE/bugzilla">
            SetHandler perl-script
            PerlResponseHandler ModPerl::Registry
            PerlOptions +ParseHeaders
            Options +ExecCGI
          </Directory>
        </IfModule>
      '';
    };
  };

  # ============================================================================
  # MySQL Database Configuration
  # ============================================================================
  services.mysql = {
    enable = true;
    package = pkgs.mariadb; # Using MariaDB (MySQL compatible)

    # Initialize database on first run
    ensureDatabases = ["testdb"]; # TODO: Rename to "bugzilla" or similar

    # Create database user with permissions
    ensureUsers = [
      {
        name = "webuser"; # TODO: Consider renaming to "bugzilla"
        ensurePermissions = {
          "testdb.*" = "ALL PRIVILEGES";
        };
      }
    ];

    # Optional: Configuration for better performance
    # settings = {
    #   mysqld = {
    #     max_allowed_packet = "64M";
    #     max_connections = 100;
    #   };
    # };
  };

  # ============================================================================
  # Perl and Required Modules
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Perl with all required Bugzilla modules
    (perl.withPackages (p:
      with p; [
        # Core modules
        mod_perl2 # Apache mod_perl integration

        # Database connectivity
        DBI # Database independent interface
        DBDmysql # MySQL driver
        DBDMariaDB # MariaDB driver

        # Web and CGI
        CGI # CGI.pm for web applications

        # Data formats
        JSON # JSON parsing and generation

        # Templating and email
        TemplateToolkit # Template processing system
        EmailSender # Email sending
        EmailMIME # MIME message construction
        EmailMIMEEncodings # MIME encodings
        EmailMessageID # Message ID generation

        # Date/Time handling
        DateTime # Date and time objects
        DateTimeTimeZone # Timezone support

        # Utilities
        URI # URI parsing
        ListMoreUtils # Additional list utilities
        AppConfig # Configuration file parsing
        ClassXSAccessor # Fast accessors
      ]))

    # Required system library
    libxcrypt # Cryptography library
  ];

  # ============================================================================
  # Environment Variables
  # ============================================================================
  environment.variables = {
    # Make Perl modules available system-wide
    PERL5LIB = "${pkgs.perl}/lib/perl5/site_perl";
  };

  # ============================================================================
  # Firewall Configuration
  # ============================================================================
  networking.firewall.allowedTCPPorts = [
    80 # HTTP (Apache)
    # 443                             # HTTPS (if you add SSL later)
  ];

  # ============================================================================
  # Notes and TODOs
  # ============================================================================
  # TODO: Consider these improvements:
  # 1. Move documentRoot outside /home for better security
  # 2. Set up HTTPS with Let's Encrypt (acme module)
  # 3. Create dedicated MySQL user with limited permissions
  # 4. Set up automatic database backups
  # 5. Consider using services.bugzilla if available in nixpkgs
}
