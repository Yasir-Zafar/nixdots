{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = with pkgs.libretro; [
        snes9x
        nestopia
        pcsx_rearmed
        mupen64plus
      ];
    })
  ];
}
