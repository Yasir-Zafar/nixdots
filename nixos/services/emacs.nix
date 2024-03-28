{ config, pkgs, ...}:{

  services = {
 
    emacs = {

      enable = false;
      install = false;
      defaultEditor = true;
      package = pkgs.emacs-pgtk;

    };

  };

}
