{pkgs, ...}: {
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;

    # pipewire's x11 bell module aborts (and dumps core) when xwayland-satellite
    # closes the X display at logout; nothing here needs the X11 bell
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
            # one list: a separate fragment used to add the headset roles,
            # which made the effective value depend on merge order
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

            # no "bluez5.codecs" list: unset means every codec pipewire has, and it picks
            # the best one both sides support (music: LDAC > aptX HD > aptX > AAC > SBC-XQ;
            # calls: LC3-SWB > mSBC > CVSD). The old list left out the call codecs, so calls
            # were stuck on CVSD (8 kHz). Buds2 Pro: AAC for music; Samsung's own SSC codec
            # doesn't exist on linux.

            # pipewire's own HFP/HSP implementation ("pipewire" was not a valid value)
            "bluez5.hfphsp-backend" = "native";
          };
        };

        # calls: when an app records from the headset (Discord, Meet), switch it to the
        # headset profile (best call codec above), and back to music quality afterwards.
        # Already wireplumber's default; written down so it's on record.
        "51-bluez-autoswitch"."wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = true;
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
