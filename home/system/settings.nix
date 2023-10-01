{ pkgs, ... }:{

  home = {

    username = "boi";
    homeDirectory = "/home/boi";
    stateVersion = "23.05";

  };

  nixpkgs = {

    config = {

      allowUnfree = true;
      allowUnfreePredicate = (_: true);

    };

  };

  programs.home-manager.enable = true;

}
