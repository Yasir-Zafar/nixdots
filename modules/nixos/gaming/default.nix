{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    # ./retroarch.nix
  ];

  # /dev/uinput for the user's "uinput" group (Charge Grinder sends input through it)
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    winetricks
    mangohud # overlay: steam launch options `mangohud %command%`

    # one library for every launcher: enable Steam/GOG/Epic/itch/... under Sources.
    # GTK3, so it picks up the Gruvbox theme from home/desktop/gtk.nix
    lutris
    heroic
    prismlauncher
    lunar-client

    dolphin-emu

    # Limbus Company bot; run it from the bspwm (X11) session (desktop/bspwm.nix)
    (callPackage ../../../pkgs/charge-grinder {})

    gnome-mahjongg
    gnome-chess
    gnome-2048
    gnome-mines
    gnome-sudoku
    aisleriot
  ];
}
