# home/services/default.nix
{
  imports = [
    #./mako.nix
    ./syncthing.nix
    ./wayland.nix
    #./batsignal.nix
  ];
}
