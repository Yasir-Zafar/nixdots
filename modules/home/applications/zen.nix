# Zen through the flake's home-manager module.
#
# `profiles` is deliberately NOT set: the module only writes profiles.ini when it is, so
# the existing profile (~/.config/zen/15738ebx.Default Profile: tabs, logins, history,
# workspaces) stays exactly as it is. What is declared here goes into Zen's policies,
# which the browser applies on top of the profile.
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

      # local omnisearch (modules/nixos/services/omnisearch.nix) as the default engine;
      # "@o" searches it explicitly, "@oi" searches its images
      SearchEngines = {
        Add = [
          {
            Name = "OmniSearch";
            URLTemplate = "http://localhost:8087/search?q={searchTerms}";
            IconURL = "http://localhost:8087/static/favicon.ico";
            Alias = "@o";
          }
          {
            Name = "OmniSearch Images";
            URLTemplate = "http://localhost:8087/images?q={searchTerms}";
            IconURL = "http://localhost:8087/static/favicon.ico";
            Alias = "@oi";
          }
        ];
        Default = "OmniSearch";
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
