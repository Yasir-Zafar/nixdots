# chat and mail (discord: nixcord.nix). Thunderbird reaches Proton through the local Bridge.
# First setup: stop the bridge service, `protonmail-bridge --cli` → login / info, start it
# again; give Thunderbird that password and accept the self-signed cert.
{pkgs, ...}: {
  home.packages = with pkgs; [
    beeper
    claude-desktop # official linux beta, own package (pkgs/claude-desktop)
  ];

  services.protonmail-bridge = {
    enable = true; # systemd user service, starts with the graphical session
    logLevel = "warn";
  };

  programs.thunderbird = {
    enable = true;

    profiles.default.isDefault = true;

    settings = {
      "mail.shell.checkDefaultClient" = false;
      "app.update.auto" = false; # updates come from nixpkgs
      "mailnews.start_page.enabled" = false;
      "mail.biff.show_alert" = true;
      "mailnews.default_sort_order" = 2; # descending
      "mailnews.default_sort_type" = 18; # by date
      "datareporting.healthreport.uploadEnabled" = false;
      "toolkit.telemetry.enabled" = false;
    };
  };

  # the account lives in Thunderbird's profile (the address is a sops secret):
  # IMAP 127.0.0.1:1143, SMTP 1025, STARTTLS. Old declaration:
  # accounts.email.accounts.proton = {
  #   inherit address realName;
  #   userName = address;
  #   primary = true;
  #   flavor = "plain";
  #
  #   imap = {
  #     host = "127.0.0.1";
  #     port = 1143;
  #     tls = bridgeTls;
  #   };
  #
  #   smtp = {
  #     host = "127.0.0.1";
  #     port = 1025;
  #     tls = bridgeTls;
  #   };
  #
  #   thunderbird = {
  #     enable = true;
  #     profiles = ["default"];
  #   };
  # };
}
