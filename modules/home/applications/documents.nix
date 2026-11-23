{
  pkgs,
  my,
  ...
}: let
  c = my.colors;

  # markdown editor; preview css recoloured to gruvbox
  apostrophe = pkgs.apostrophe.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        cat >> $out/share/apostrophe/media/css/web/adwaita.css <<'EOF'
        @media (prefers-color-scheme: dark) {
          :root {
            --text-color: ${c.fg};
            --background-color: ${c.bg};
            --alt-background-color: ${c.bg1};
            --link-color: ${c.blue};
            --blockquote-text-color: ${c.gray};
            --blockquote-border-color: ${c.bg2};
            --header-border-color: ${c.bg2};
            --hr-background-color: ${c.bg2};
            --table-tr-border-color: ${c.bg3};
            --table-td-border-color: ${c.bg2};
            --kbd-text-color: ${c.fg};
            --kbd-background-color: ${c.bg1};
            --kbd-border-color: ${c.bg3};
            --kbd-shadow-color: ${c.gray};
          }
        }
        EOF
      '';
  });
in {
  home.packages = with pkgs; [
    papers
    foliate
    obsidian
    apostrophe
    gnome-text-editor
    gnome-decoder
    # gnome-frog # ocr: grab text from images (posthog broken in nixpkgs, 2026-10)
    # errands
    # spelling from the hunspell/hyphen dicts below, Calibri/Cambria stand-ins are system fonts
    libreoffice
    hunspellDicts.en_GB-ise # spell check for libreoffice and gtk apps
    hyphenDicts.en_GB # hyphenation (justified text, Tools > Language > Hyphenation)
    pdfarranger # merge, split, rotate, reorder pdf pages
    # gnome-notes
    # thunderbird
    # zoom-us
  ];
}
