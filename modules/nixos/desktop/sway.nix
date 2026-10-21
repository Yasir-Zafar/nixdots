# sway: a second session for apps that don't support niri (Charge Grinder, see
# modules/nixos/gaming/default.nix). niri stays the default; pick "Sway" in the greeter.
# The nixpkgs module already sets up the wlr screencast portal, the sway-session systemd
# target (so graphical-session services like the polkit agent start) and the session file.
# User config: modules/home/desktop/sway.nix
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # sway doesn't set this itself, and the portals (and Charge Grinder) pick their backend by it
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway
    '';
  };

  # the default chooser is a slurp overlay; missing the click cancels the capture
  # ("Portal SelectSources denied or cancelled"), so share an output without asking
  xdg.portal.wlr.settings.screencast.chooser_type = "none";
}
