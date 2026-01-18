{pkgs, ...}: {
  services.httpd = {
    enable = true;
    adminAddr = "you@example.com";
    enablePHP = false; # not needed
    extraModules = ["cgi" "cgid" "perl"];
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

  # Enable MySQL (MariaDB)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # Ensure the database initializes on first run
    ensureDatabases = ["testdb"];

    # Create a default user (optional)
    ensureUsers = [
      {
        name = "webuser";
        ensurePermissions = {
          "testdb.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Install Perl and common modules
  environment.systemPackages = with pkgs; [
    (perl.withPackages (p:
      with p; [
        mod_perl2
        DBI
        DBDmysql
        DBDMariaDB
        CGI
        JSON
        TemplateToolkit
        EmailSender
        EmailMIME
        EmailMIMEEncodings
        EmailMessageID
        DateTime
        DateTimeTimeZone
        URI
        ListMoreUtils
        AppConfig
        ClassXSAccessor
      ]))
    libxcrypt
  ];

  # Make Perl available in environment PATH
  environment.variables = {
    PERL5LIB = "${pkgs.perl}/lib/perl5/site_perl";
  };

  # Open firewall for HTTP
  networking.firewall.allowedTCPPorts = [80];
}
