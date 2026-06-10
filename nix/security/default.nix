{
  imports = [];

  security = {
    sudo.wheelNeedsPassword = false;

    polkit.enable = true;

    apparmor.enable = false;
  };
}
