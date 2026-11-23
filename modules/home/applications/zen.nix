# Zen. Never set `profiles`: it rewrites profiles.ini; everything here is policies.
{
  inputs,
  lib,
  ...
}: let
  # installed like a normal add-on (can be disabled, updates itself); reinstalled when missing
  addon = id: {
    installation_mode = "normal_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${lib.strings.escapeURL id}/latest.xpi";
  };
in {
  imports = [inputs.zen-browser.homeModules.beta];

  programs.zen-browser = {
    enable = true;

    policies = {
      DisableAppUpdate = true; # updates come from the flake
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true; # xdg default is set in preferred-apps.nix

      # omnisearch (modules/nixos/services/omnisearch.nix) is off; back to google
      SearchEngines.Default = "Google";

      # from the live prefs.js (2026-11-05); only defaults, the UI wins. zen.*/font.*/sidebar.* stay in the profile
      Preferences =
        lib.mapAttrs (_: v: {
          Value = v;
          Status = "default";
        }) {
          "browser.translations.enable" = false;
          "browser.ai.control.translations" = "blocked";
          "browser.urlbar.suggest.searches" = false;
          "browser.download.useDownloadDir" = false; # ask where to save
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "network.dns.disablePrefetch" = true;
          "network.prefetch-next" = false;
          "network.http.speculative-parallel-limit" = 0;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

      ExtensionSettings =
        lib.genAttrs [
          "uBlock0@raymondhill.net" # uBlock Origin
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
          "sponsorBlocker@ajay.app" # SponsorBlock
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # Return YouTube Dislike
          "idcac-pub@guus.ninja" # I still don't care about cookies
          "{91aa3897-2634-4a8a-9092-279db23a7689}" # Zen Internet (site themes)
          "{f209234a-76f0-4735-9920-eb62507a54cd}" # Unpaywall
          "button@scholar.google.com" # Google Scholar Button
          "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" # Indie Wiki Buddy
        ]
        addon;
    };
  };
}
