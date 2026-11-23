# launchers, emulators, games (system side: nixos/gaming)
{pkgs, ...}: {
  home.packages = with pkgs; [
    # one library for every launcher (Sources)
    lutris
    heroic

    # windows games outside steam, a prefix per game; no upstream 'unsupported' popup
    (bottles.override {removeWarningPopup = true;})
    prismlauncher

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
