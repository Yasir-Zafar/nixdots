# nixos/services/sound.nix
{ config, lib, pkgs, ... }:

{
  # Use PipeWire for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # High quality audio settings
    wireplumber.configPackages = [
      (pkgs.writeTextFile {
        name = "wireplumber-high-quality";
        destination = "/share/wireplumber/main.lua.d/51-high-quality.lua";
        text = ''
          table.insert(alsa_monitor.rules, {
            matches = {
              {
                -- Apply to all audio devices
                { "node.name", "matches", "alsa_output.*" },
              },
            },
            apply_properties = {
              ["audio.format"] = "S32LE",
              ["audio.rate"] = 48000,
              ["api.alsa.period-size"] = 256,
              ["api.alsa.headroom"] = 1024,
            },
          })
        '';
      })
    ];
  };

  # Low latency audio settings
  boot.kernelParams = [ "threadirqs" ];

  # Audio-related packages
  environment.systemPackages = with pkgs; [
    easyeffects # Audio effects for PipeWire
    pavucontrol # PulseAudio/PipeWire control GUI
  ];
}
