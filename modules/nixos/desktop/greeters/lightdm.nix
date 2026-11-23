# LightDM with the gtk greeter, themed from the repo's assets/
{
  pkgs,
  my,
  ...
}: let
  gruvbox = import ../../../../lib/gruvbox-gtk.nix {inherit pkgs my;};
in {
  services.xserver = {
    enable = true; # LightDM still lives under the xserver service
    displayManager.lightdm = {
      enable = true;
      background = my.assets + "/wall.jpg";
      greeters.gtk = {
        enable = true;
        # same theme and icon packages as home (lib/gruvbox-gtk.nix)
        inherit (gruvbox) theme;
        iconTheme = gruvbox.icons;
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        extraConfig = ''
          # cursor speed (1 = default, higher is faster)
          cursor-speed = 0.5

          keyboard-opened = false
          indicators = ~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power
        '';
      };
    };
  };

}
