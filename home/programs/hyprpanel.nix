# *.nix
{ inputs, pkgs, ...}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  programs.hyprpanel = {
    enable = true;
  };

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
