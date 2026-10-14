_: {
  environment = {
    variables = {
      EDITOR = "nvim"; # root/sudo; the user session gets the rest from home-manager

      # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      # native deps (openssl…) come from a project's dev shell now (templates/)
    };

    # Wayland variables live in desktop/niri.nix
    sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
