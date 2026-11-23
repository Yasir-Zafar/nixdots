# Helium, second browser close to Zen. Policies (settings, extensions): nixos/desktop/helium.nix
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.helium.homeModules.default];

  programs.helium = {
    enable = true;
    package = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium;

    # wayland is already on (the package adds --ozone-platform-hint=auto under NIXOS_OZONE_WL)
    flags = [
      # va-api video decode on the intel igpu (youtube etc. without burning the cpu)
      "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
      # middle-click autoscroll, like zen/firefox
      "--enable-blink-features=MiddleClickAutoscroll"
    ];
  };

  # DRM (Spotify, Netflix…): point helium at nixpkgs' widevine instead of its own download
  home.file.".config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text =
    builtins.toJSON {Path = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm";};
}
