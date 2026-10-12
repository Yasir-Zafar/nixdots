# image, pixel art, 3d, game dev, quick media editing
{pkgs, ...}: {
  home.packages = with pkgs; [
    # gimp
    # krita
    pinta
    pixelorama

    blender
    godot

    video-trimmer
    switcheroo # image format conversion
    curtail # image compression
  ];
}
