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
{pkgs, ...}: {
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

  # The Proton account was declared here. The address now lives only in
  # secrets/secrets.yaml (proton_address), so the public repo doesn't carry it, and an
  # e-mail account can't be built from a runtime secret. Thunderbird keeps the account
  # in its own profile (prefs.js), so mail works as before. To recreate it on a new
  # machine: Thunderbird → new account → IMAP 127.0.0.1:1143 / SMTP 127.0.0.1:1025,
  # STARTTLS, user = the proton address, password from `protonmail-bridge --cli` → info.
  # The old declaration, for reference (address = the proton address, realName = my
  # full name, bridgeTls = { enable = true; useStartTls = true; }):
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
