{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.millennium.overlays.default];
  programs = {
    steam = {
      enable = true;

      # Millennium theming; if a Steam update breaks it, comment these out
      # package = pkgs.millennium-steam.override {
      #   extraArgs = "-system-composer";
      # };

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
