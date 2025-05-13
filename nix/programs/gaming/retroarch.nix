{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.libretro.retroarchWithCores {
      cores = with pkgs.libretro; [
        snes9x
        nestopia
        pcsx_rearmed
        mupen64plus
      ];
    })
  ];
}
