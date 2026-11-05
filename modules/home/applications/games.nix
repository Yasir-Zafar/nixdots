# launchers, emulators and games. The system side (steam, gamemode, uinput, the
# gaming sysctls) is in modules/nixos/gaming.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # one library for every launcher: enable Steam/GOG/Epic/itch/... under Sources.
    # GTK3, so it picks up the Gruvbox theme from desktop/gtk.nix
    lutris
    heroic
    prismlauncher
    lunar-client

    dolphin-emu

    # Limbus Company bot; run it from the bspwm (X11) session (desktop/bspwm.nix)
    charge-grinder

    gnome-mahjongg
    gnome-chess
    gnome-2048
    gnome-mines
    gnome-sudoku
    aisleriot
  ];
}
