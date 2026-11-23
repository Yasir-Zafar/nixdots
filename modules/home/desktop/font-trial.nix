# fonts on trial (docs/PROSPECTS.md), user-only and nobody's default
{
  lib,
  pkgs,
  ...
}: {
  # makes fonts from home.packages visible to fontconfig (and runs fc-cache on switch)
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # terminal (mono)
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

    # bitmap / pixel; spleen and tamzen fonts.dir indexes collide, hiPrio keeps spleen's
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
