{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.millennium.overlays.default];
  programs = {
    steam = {
      enable = true;

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
