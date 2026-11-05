{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.millennium.overlays.default];
  programs = {
    steam = {
      enable = true;

      # Millennium (steam client theming). If it lags behind a Steam client update and
      # breaks, comment these three lines out again to get plain Steam back
      package = pkgs.millennium-steam.override {
        extraArgs = "-system-composer";
      };

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  hardware.graphics.enable32Bit = true;
}
