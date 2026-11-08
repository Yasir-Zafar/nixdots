# Fonts on trial, from docs/PROSPECTS.md. Installed for the user only and set as nobody's
# default, so nothing changes until one is picked by name somewhere. Keepers move to
# modules/nixos/desktop/fonts.nix (or stylix.nix); the rest get dropped from this list.
# Not here: Iosevka and Noto (already system fonts), Manrope, Outfit and Space Grotesk
# (only in google-fonts, which downloads the whole collection).
{
  lib,
  pkgs,
  ...
}: {
  # makes fonts from home.packages visible to fontconfig (and runs fc-cache on switch)
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # terminal (mono). Ghostty has the nerd font icons built in, so the plain fonts work
    fira-code
    cascadia-code
    monaspace.static # one variant; the full package is all four (static, variable, frozen, nerd)
    hack-font
    commit-mono
    victor-mono
    lilex
    martian-mono
    _0xproto
    fantasque-sans-mono
    departure-mono

    # bitmap / pixel (crisp at their exact sizes only). spleen and tamzen both ship an X11
    # fonts.dir index, which collides; hiPrio keeps spleen's (fontconfig doesn't use it)
    cozette
    (lib.hiPrio spleen)
    tamzen
    terminus_font_ttf # vector build; the bitmap one is PCF/OTB plus another fonts.dir
    scientifica

    # bar / UI (sans)
    geist-font
    (ibm-plex.override {families = ["sans" "serif" "mono"];}) # not the CJK/Arabic/Thai/... ones
    rubik
    figtree
    lexend
    cantarell-fonts

    # reading (serif)
    atkinson-hyperlegible-next
    literata
    merriweather
    crimson-pro
    eb-garamond
  ];
}
