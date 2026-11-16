# Policies for Helium (modules/home/applications/helium.nix), mirroring Zen's (zen.nix).
# Chromium-based browsers read policies only from /etc/chromium/policies; nixos' chromium
# module just writes those files (it installs no browser). Nothing else here reads them.
#   managed      enforced (greyed out in settings): extensions, search, privacy
#   recommended  defaults only, changeable in settings (like Zen's Status = "default")
# Check what applied: helium://policy
{my, ...}: let
  # installed like a normal extension (can be disabled, updates itself), reinstalled when missing.
  # Helium rewrites the web store URL to its own privacy proxy (Helium services)
  extension = {
    installation_mode = "normal_installed";
    update_url = "https://clients2.google.com/service/update2/crx";
  };
in {
  programs.chromium = {
    enable = true;

    extraOpts = {
      ExtensionSettings = builtins.mapAttrs (_: _: extension) {
        "nngceckbapebfimnlniiiahkandclblb" = "Bitwarden";
        "mnjggcdmjocbbbhaepdhchncahnbgone" = "SponsorBlock";
        "gebbhagfogifgggkldgodflihgfeippi" = "Return YouTube Dislike";
        "edibdbjcniadpccecjdfdjjppcpchdlm" = "I still don't care about cookies";
        "iplffkdpngmdjhlpjmppncnlhomiipha" = "Unpaywall";
        "ldipcbpaocekfooobnbcddclnhejkcpn" = "Google Scholar Button";
        "fkagelmloambgokoeokbpihmgpkbgbfm" = "Indie Wiki Buddy";
      };

      # omnisearch (modules/nixos/services/omnisearch.nix) is off; back to google
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";

      # Bitwarden handles passwords; no google account, sync or usage reports
      PasswordManagerEnabled = false;
      BrowserSignin = 0;
      SyncDisabled = true;
      MetricsReportingEnabled = false;
      DefaultBrowserSettingEnabled = false; # Zen is the default (preferred-apps.nix)

      SpellcheckEnabled = true;
      SpellcheckLanguage = ["en-GB"];

      BrowserThemeColor = my.colors.bg; # gruvbox toolbar/tab colour
    };

    # defaults from Zen's prefs, changeable in helium://settings
    extraOptsRecommended = {
      TranslateEnabled = false; # browser.translations.enable = false
      SearchSuggestEnabled = false; # browser.urlbar.suggest.searches = false
      PromptForDownloadLocation = true; # browser.download.useDownloadDir = false
      NetworkPredictionOptions = 2; # no dns/link prefetch (network.dns.disablePrefetch…)
      BackgroundModeEnabled = false; # quit when the last window closes
    };
  };
}
