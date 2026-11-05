# EasyEffects (8.x) through home-manager's module: one output preset per headphone, loaded on
# its own when that device becomes the output (autoload files below). Everything else
# (laptop speakers, HDMI) falls back to "flat", so a headphone EQ never sticks to the speakers.
# Presets and autoload rules are store links: change them here, not in the app.
# Before this used a hand-written systemd unit; home-manager's module now does the same job.
{lib, ...}: let
  # AutoEQ ParametricEQ.txt -> EasyEffects equalizer. Each filter line becomes
  # (f "<type>" <Fc> <gain> <Q>); the Preamp line is the preamp argument. "APO (DR)" makes
  # the bands behave like Equalizer APO's, which is what AutoEQ computes against.
  f = type: frequency: gain: q: {inherit type frequency gain q;};
  autoEq = preamp: filters: let
    types = {
      LSC = "Lo-shelf";
      PK = "Bell";
      HSC = "Hi-shelf";
    };
    bands = lib.listToAttrs (lib.imap0 (i: b: {
        name = "band${toString i}";
        value = {
          type = types.${b.type};
          mode = "APO (DR)";
          slope = "x1";
          solo = false;
          mute = false;
          inherit (b) frequency gain q;
        };
      })
      filters);
  in {
    output = {
      blocklist = [];
      plugins_order = ["equalizer#0"];
      "equalizer#0" = {
        bypass = false;
        input-gain = preamp;
        output-gain = 0.0;
        mode = "IIR";
        decramp = "Off";
        num-bands = builtins.length filters;
        split-channels = false;
        balance = 0.0;
        pitch-left = 0.0;
        pitch-right = 0.0;
        left = bands;
        right = bands;
      };
    };
  };

  # rule: when <device> (pipewire node.name) is the output on <route> (the route's
  # description, as EasyEffects shows it), load <preset>
  autoload = {
    device,
    description,
    route,
    preset,
  }: {
    "easyeffects/autoload/output/${device}:${route}.json".text = builtins.toJSON {
      inherit device;
      device-description = description;
      device-profile = route;
      preset-name = preset;
    };
  };
in {
  services.easyeffects = {
    enable = true;

    extraPresets = {
      flat.output = {
        blocklist = [];
        plugins_order = [];
      };

      # oratory1990's measurement, from AutoEQ (results/oratory1990/in-ear/Samsung Galaxy Buds2 Pro)
      buds2-pro = autoEq (-2.3) [
        (f "LSC" 105 (-2.3) 0.70)
        (f "PK" 7526 2.2 2.78)
        (f "PK" 266 (-0.8) 1.35)
        (f "PK" 3426 (-2.3) 3.70)
        (f "PK" 64 2.2 1.18)
        (f "HSC" 10000 (-3.8) 0.70)
        (f "PK" 8817 1.6 2.28)
        (f "PK" 2283 1.2 3.75)
        (f "PK" 4955 (-1.2) 5.11)
        (f "PK" 977 1.0 5.18)
      ];

      # no Pro X in AutoEQ; closest is crinacle's EDX Pro (results/crinacle/711 in-ear/KZ EDX Pro)
      edx-pro-x = autoEq (-5.1) [
        (f "LSC" 105 (-2.3) 0.70)
        (f "PK" 169 (-4.0) 0.82)
        (f "PK" 9836 2.9 0.18)
        (f "PK" 783 3.2 1.23)
        (f "PK" 2062 (-4.8) 2.53)
        (f "HSC" 10000 (-6.1) 0.70)
        (f "PK" 9508 3.3 2.86)
        (f "PK" 4965 (-5.7) 5.27)
        (f "PK" 3516 2.7 3.58)
        (f "PK" 6291 3.2 5.44)
      ];
    };

    # no rule for the current device -> "flat"
    settings.Window = {
      outputAutoloadingUsesFallback = true;
      outputAutoloadingFallbackPreset = "flat";
    };
  };

  xdg.dataFile = lib.mkMerge [
    (autoload {
      device = "bluez_output.CC_F8_26_89_7E_51.1";
      description = "Yasir's Buds2 Pro";
      route = "Headphones"; # in music (A2DP) mode; calls use the headset profile, no EQ
      preset = "buds2-pro";
    })
    # wired (KZ EDX Pro X): the laptop's headphone jack (its own sink, separate from the speakers)
    (autoload {
      device = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink";
      description = "Core Ultra 200H/200V Series Processors HD Audio Headphones";
      route = "Headphones";
      preset = "edx-pro-x";
    })
  ];
}
