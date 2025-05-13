# *.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ags
    libgtop
    dart-sass
    wl-clipboard
    upower

    power-profiles-daemon
    grimblast
    wf-recorder

    hyprpicker
    hyprsunset
    btop
  ];
}
