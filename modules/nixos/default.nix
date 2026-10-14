# Every system module. To turn one off, comment out its line.
{
  imports = [
    ./nix.nix
    ./hardware
    ./boot
    ./desktop
    ./gaming
    ./development
    ./users
    ./security
    ./services
  ];
}
