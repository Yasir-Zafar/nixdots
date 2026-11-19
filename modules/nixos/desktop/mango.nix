# mango (github:mangowm/mango): a dwl-based tiling compositor, dwm tags + awesome-style
# layouts. The flake's module installs mango + mmsg, adds the "Mango" session for the
# greeter and sets mango's portals: gtk for most things, wlr for screencast/screenshot
# (its picker is slurp: click the monitor to share). niri.nix stays imported: its
# session variables, polkit agent and tools are shared, and niri stays a session.
# User config (binds, rules, look): modules/home/desktop/mango.nix
{
  programs.mango.enable = true;
}
