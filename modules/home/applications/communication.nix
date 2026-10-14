# chat and mail (discord lives in nixcord.nix)
#
# Mail: Thunderbird talks to Proton through the local Bridge (127.0.0.1).
# One-time setup after the first switch:
#   1. `systemctl --user stop protonmail-bridge`, then `protonmail-bridge --cli`; `login`
#      (credentials go into gnome-keyring), `info` shows the bridge username and its
#      generated password; `exit`, then `systemctl --user start protonmail-bridge`
#      (a second instance can't take the lock while the service runs)
#   2. open Thunderbird, enter that bridge password, and accept the bridge's self-signed
#      certificate once (also for smtp port 1025)
# Theme: the "Gruvbox Dark Thunderbird" add-on, installed by hand (no stylix target).
{
  pkgs,
  my,
  ...
}: let
  address = my.mail;
  realName = my.fullName;

  bridgeTls = {
    enable = true;
    useStartTls = true; # bridge listens in plain on localhost and upgrades with STARTTLS
  };
in {
  home.packages = with pkgs; [
    beeper
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

  accounts.email.accounts.proton = {
    inherit address realName;
    userName = address;
    primary = true;
    flavor = "plain";

    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls = bridgeTls;
    };

    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls = bridgeTls;
    };

    thunderbird = {
      enable = true;
      profiles = ["default"];
    };
  };
}
