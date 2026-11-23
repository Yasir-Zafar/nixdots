{pkgs, ...}: {
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;

    # pipewire's x11 bell aborts when xwayland-satellite closes at logout
    extraConfig.pipewire."90-no-x11-bell"."context.properties"."module.x11.bell" = false;

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
            # one list: a split fragment made the value depend on merge order
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];

            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;

            # no codec list: pipewire picks the best both sides support (an old list kept calls on CVSD)

            # pipewire's own HFP/HSP implementation ("pipewire" was not a valid value)
            "bluez5.hfphsp-backend" = "native";
          };
        };

        # switch to the headset profile while an app records (wireplumber default, kept on record)
        "51-bluez-autoswitch"."wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = true;
        };
      };
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pwvucontrol # volume mixer (GTK4, talks to pipewire directly); replaced pavucontrol 2026-11-08
  ];
}
