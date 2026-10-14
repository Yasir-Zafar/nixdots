# LightDM with the gtk greeter, themed from the repo's assets/
{
  pkgs,
  my,
  ...
}: {
  services.xserver = {
    enable = true; # LightDM still lives under the xserver service
    displayManager.lightdm = {
      enable = true;
      background = my.assets + "/wall.jpg";
      greeters.gtk = {
        enable = true;
        # Reference the files relative to this .nix file
        theme.package = pkgs.runCommand "local-theme" {} ''
          mkdir -p $out/share/themes
          cp -r ${my.assets + "/Gruvbox-Green-Dark-Medium"} $out/share/themes/Gruvbox-Green-Dark-Medium
        '';
        theme.name = "Gruvbox-Green-Dark-Medium";

        iconTheme.package = pkgs.runCommand "local-icons" {} ''
          mkdir -p $out/share/icons
          cp -r ${my.assets + "/Gruvbox-Plus-Dark"} $out/share/icons/Gruvbox-Plus-Dark
        '';
        iconTheme.name = "Gruvbox-Plus-Dark";
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        # LightDM can actually read your home folder easier,
        # but using a nix path is still safer.
        extraConfig = ''
          # Set the cursor speed/sensitivity
          # Note: LightDM uses X11 settings; 1 is default, higher is faster
          cursor-speed = 0.5

          # You can also set specific accessibility or input tweaks here
          keyboard-opened = false
          indicators = ~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power
        '';
      };
    };
  };

  # gtk-engine-murrine (gtk2 theme engine) used to be installed here; nixpkgs removed it with gtk2
}
