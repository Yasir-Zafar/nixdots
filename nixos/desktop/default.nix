{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./niri.nix
  ];

  services.xserver = {
    enable = true; # LightDM still lives under the xserver service
    displayManager.lightdm = {
      enable = true;
      background = "/home/boi/Pictures/Wallpapers/10.png";
      greeters.gtk = {
        enable = true;
        # Reference the files relative to this .nix file
        theme.package = pkgs.runCommand "local-theme" {} ''
          mkdir -p $out/share/themes
          cp -r ${./../../assets/Gruvbox-Green-Dark-Medium} $out/share/themes/Gruvbox-Green-Dark-Medium
        '';
        theme.name = "Gruvbox-Green-Dark-Medium";

        iconTheme.package = pkgs.runCommand "local-icons" {} ''
          mkdir -p $out/share/icons
          cp -r ${./../../assets/Gruvbox-Plus-Dark} $out/share/icons/Gruvbox-Plus-Dark
        '';
        iconTheme.name = "Gruvbox-Plus-Dark";
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        # LightDM can actually read your home folder easier,
        # but using a nix path is still safer.
      };
    };
  };

  services = {
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
    };

    gvfs.enable = true;
  };

  services.flatpak.enable = true;

  environment = {
    pathsToLink = ["share/thumbnailers"];

    systemPackages = with pkgs; [
      gnome-calendar
      gnome-calculator
      gnome-usage
      gnome-disk-utility
      file-roller
      gnome-autoar

      sassc
      gtk-engine-murrine
      gnome-themes-extra

      libheif
      libheif.out

      inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default

      cage
    ];
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=Downloads
    TEMPLATES=
    PUBLICSHARE=
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
