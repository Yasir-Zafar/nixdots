{
  config,
  pkgs,
  ...
}: {
  services = {
    emacs = {
      enable = false;
      install = true;
      defaultEditor = true;
      package = pkgs.emacs-pgtk;
    };
  };
}
