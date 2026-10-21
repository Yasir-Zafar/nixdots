# Desktop: niri + noctalia, fonts, media libraries, and one greeter.
# Every greeter has its own set of problems, so all of them are kept in ./greeters:
#   sysc-greet.nix  sysc-greet on greetd (active)
#   tuigreet.nix    tuigreet on greetd (the previous default)
#   lightdm.nix     lightdm, themed from assets/
#   gdm.nix         gdm
#   ly.nix          ly
# Swap the greeter line below to change it, or boot-test one with `nx try <greeter>`.
# ./gnome.nix is the full gnome desktop from before niri (not imported).
{
  imports = [
    ./fonts.nix
    ./media-libs.nix
    ./niri.nix
    ./sway.nix # second session for apps without niri support
    ./flatpak.nix
    ./greeters/common.nix
    ./greeters/sysc-greet.nix
  ];
}
