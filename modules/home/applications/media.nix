# playback, music, podcasts, recording
{pkgs, ...}: {
  home.packages = with pkgs; [
    showtime
    stremio-linux-shell
    pear-desktop
    amberol
    gnome-podcasts
    ffmpeg

    obs-studio
    # kooha
  ];

  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto-safe";
      vo = "gpu-next"; # libplacebo renderer, mpv's recommended one
      profile = "high-quality"; # renamed from gpu-hq
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
    };

    # lighter settings that keep playback smooth on the iGPU without the charger
    # (applied by the battery.lua script below) and for anything above 1440p
    profiles = {
      battery = {
        scale = "spline36";
        cscale = "spline36";
        interpolation = false;
        video-sync = "audio";
      };
      big-video = {
        profile-cond = "height > 1440";
        profile-restore = "copy";
        scale = "spline36";
        cscale = "spline36";
        interpolation = false;
      };
    };
  };

  # mpv has no battery property, so check the AC adapter once at startup
  xdg.configFile."mpv/scripts/battery.lua".text = ''
    local f = io.open("/sys/class/power_supply/ACAD/online", "r")
    if f then
      local online = f:read("*l")
      f:close()
      if online == "0" then
        mp.commandv("apply-profile", "battery")
        mp.msg.info("on battery: using the lighter 'battery' profile")
      end
    end
  '';
}
