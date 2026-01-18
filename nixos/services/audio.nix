# nixos/services/audio.nix
# PipeWire audio configuration with Bluetooth enhancements
{pkgs, ...}: {
  # ============================================================================
  # PipeWire Audio System
  # ============================================================================
  services.pipewire = {
    enable = true;

    # ALSA support (traditional Linux audio)
    alsa = {
      enable = true;
      support32Bit = true; # Required for Steam and Wine games
    };

    # PulseAudio compatibility layer
    pulse.enable = true;

    # -------------------------------------------------------------------------
    # WirePlumber Configuration (PipeWire session manager)
    # -------------------------------------------------------------------------
    wireplumber = {
      extraConfig = {
        # Bluetooth Audio Configuration
        "50-bluez" = {
          "monitor.bluez.rules" = [
            {
              # Match all Bluetooth audio devices
              matches = [{"device.name" = "~bluez_card.*";}];

              actions = {
                update-props = {
                  # Auto-connect to A2DP profiles (high-quality audio)
                  "bluez5.auto-connect" = [
                    "a2dp_sink" # Headphones/Speakers
                    "a2dp_source" # Microphone
                  ];

                  # Enable hardware volume control
                  "bluez5.hw-volume" = [
                    "a2dp_sink"
                    "a2dp_source"
                  ];
                };
              };
            }
          ];

          # Bluetooth adapter properties
          "monitor.bluez.properties" = {
            # Supported Bluetooth audio profiles
            "bluez5.roles" = [
              "a2dp_sink" # Headphones/Speakers (output)
              "a2dp_source" # Microphone (input)
            ];

            # Supported audio codecs (ordered by quality)
            "bluez5.codecs" = [
              "ldac" # Sony LDAC (highest quality)
              "aptx_hd" # Qualcomm aptX HD
              "aptx" # Qualcomm aptX
              "aptx_ll" # aptX Low Latency
              "aptx_ll_duplex" # aptX LL bidirectional
              "opus_05_pro" # Opus profiles
              "opus_05_71"
              "opus_05_51"
              "opus_05"
              "opus_05_duplex"
              "aac" # AAC (Apple devices)
              "sbc_xq" # SBC XQ (enhanced SBC)
            ];

            # Use PipeWire for headset calls (better quality than ofono)
            "bluez5.hfphsp-backend" = "pipewire";
          };
        };

        # Additional Bluetooth enhancements
        "bluetoothEnhancements" = {
          "monitor.bluez.properties" = {
            # Enable enhanced codecs
            "bluez5.enable-sbc-xq" = true; # Enhanced SBC codec
            "bluez5.enable-msbc" = true; # mSBC for calls
            "bluez5.enable-hw-volume" = true; # Hardware volume control

            # Additional profiles for headsets
            "bluez5.roles" = [
              "hsp_hs" # Headset profile
              "hsp_ag" # Audio gateway
              "hfp_hf" # Hands-free profile
              "hfp_ag" # Audio gateway (HFP)
            ];
          };
        };
        # FIXED: Disable X11 bell errors
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

  # ============================================================================
  # Audio Backend Configuration
  # ============================================================================
  # Disable PulseAudio (using PipeWire instead)
  services.pulseaudio.enable = false;

  # Enable RealtimeKit for low-latency audio
  # Gives audio processes higher priority for better performance
  security.rtkit.enable = true;

  # ============================================================================
  # Audio Utilities
  # ============================================================================
  environment.systemPackages = with pkgs; [
    pavucontrol # PulseAudio volume control (works with PipeWire)
    # Additional tools to consider:
    # helvum                                            # PipeWire patchbay (graphical)
    # qpwgraph                                          # Qt PipeWire graph editor
    # easyeffects                                       # Audio effects (EQ, compressor, etc.)
  ];
}
