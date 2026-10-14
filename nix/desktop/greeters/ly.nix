# ly: TUI display manager
_: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix"; # none | doom | matrix | colorcycle
      clock = "%H:%M  %a %d %b";
      vi_mode = false;
      asterisk = "*";
    };
  };

  # gtk-engine-murrine (gtk2 theme engine) used to be installed here; nixpkgs removed it with gtk2
}
