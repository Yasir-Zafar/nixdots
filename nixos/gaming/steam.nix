{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirwall = true;
    gamescopeSession.enable = true;
  };

  hardware.graphics.enable32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}
