# *.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    ags
    libgtop
    dart-sass
    wl-clipboard
    upower

    grimblast
    wf-recorder

    hyprpicker
    hyprsunset
    btop
  ];
}
