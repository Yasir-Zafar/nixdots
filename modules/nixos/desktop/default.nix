# mango + noctalia (default), niri, bspwm (X11), fonts, media libs, one greeter.
#   sysc-greet.nix  sysc-greet on greetd (active)
#   tuigreet.nix    tuigreet on greetd (the previous default)
#   lightdm.nix     lightdm, themed from assets/
#   gdm.nix         gdm
#   ly.nix          ly
# greeters in ./greeters: swap the line below, or boot-test with `nx try <greeter>`. ./gnome.nix: old, not imported
{
  imports = [
    ./fonts.nix
    ./media-libs.nix
    ./niri.nix
    ./mango.nix # default session (sysc-greet preselects it)
    ./bspwm.nix # X11 session for apps without niri support
    ./flatpak.nix
    ./helium.nix # helium's browser policies (the browser itself is in home)
    ./greeters/common.nix
    ./greeters/sysc-greet.nix
  ];
}
