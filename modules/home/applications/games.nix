# launchers, emulators and games. The system side (steam, gamemode, uinput, the
# gaming sysctls) is in modules/nixos/gaming.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # one library for every launcher: enable Steam/GOG/Epic/itch/... under Sources.
    # GTK3, so it picks up the Gruvbox theme from desktop/gtk.nix
    lutris
    heroic

    # windows games/apps outside steam, one wine prefix ("bottle") per game; runners, dxvk and
    # bottles live in ~/.local/share/bottles. nixpkgs' build (gamemode, mangohud, gamescope
    # included), without the "unsupported build" popup upstream shows outside flatpak.
    # The system wine (nixos/users/packages.nix) still opens a double-clicked .exe.
    (bottles.override {removeWarningPopup = true;})
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
