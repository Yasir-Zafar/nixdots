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
    # launchers, emulators and games: home (modules/home/applications/games.nix)
  ];
}
