{ pkgs, ...}:{

  services = {
 
    emacs = {

      enable = true;
      install = true;
      package = pkgs.emacs-pgtk;

    };

  };

}
