{pkgs, ...}: {
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;

    wireplumber = {
      extraConfig = {
        "50-bluez" = {
          "monitor.bluez.rules" = [
            {
              matches = [{"device.name" = "~bluez_card.*";}];

              actions = {
                update-props = {
                  "bluez5.auto-connect" = [
                    "a2dp_sink"
                    "a2dp_source"
                  ];

                  "bluez5.hw-volume" = [
                    "a2dp_sink"
                    "a2dp_source"
                  ];
                };
              };
            }
          ];

          "monitor.bluez.properties" = {
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
            ];

            "bluez5.codecs" = [
              "ldac"
              "aptx_hd"
              "aptx"
              "aptx_ll"
              "aptx_ll_duplex"
              "opus_05_pro"
              "opus_05_71"
              "opus_05_51"
              "opus_05"
              "opus_05_duplex"
              "aac"
              "sbc_xq"
            ];

            "bluez5.hfphsp-backend" = "pipewire";
          };
        };

        "bluetoothEnhancements" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;

            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };

        "51-disable-x11-bell" = {
          "monitor.alsa.rules" = [
            {
              matches = [{"node.name" = "~alsa_.*";}];
              actions.update-props."api.alsa.disable-x11-bell" = true;
            }
          ];
        };
      };
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
