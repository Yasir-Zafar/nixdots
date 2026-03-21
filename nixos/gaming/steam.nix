{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    gamescope = {
      enable = true;
    };
  };

  hardware.graphics.enable32Bit = true;
}
