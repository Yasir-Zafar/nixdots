{pkgs, ...}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        # kept on: press `e` on a boot entry to try kernel params for one boot (see below)
        editor = true;
      };

      timeout = 1;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    # try a param for one boot first (`e` at the boot menu); add it here only once it worked
    kernelParams = [
      # quiet boot (log level: consoleLogLevel below; nixos appends loglevel=4 after params)
      "quiet"
      "udev.log_level=3"

      # not a default here (CONFIG_INTEL_IOMMU_DEFAULT_ON unset): Intel IOMMU on
      "intel_iommu=on"

      # nested virtualisation for VMs inside VMs (harmless if unused)
      "kvm-intel.nested=1"

      "acpi_backlight=native" # only intel_backlight exists; keeps it that way
      "i8042.nopnp" # keyboard/touchpad controller probing

      # removed 2026-10-15 without a test boot; re-add one if its symptom shows up:
      #   "acpi_osi=Linux"  odd fan/thermal/brightness, missing hotkeys
      #   "snd-intel-dspcfg.dsp_driver=1"  no sound at all
      #   "nvme_core.default_ps_max_latency_us=5500"  nvme timeouts, hangs after suspend
    ];

    consoleLogLevel = 3; # errors only on the console during boot

    initrd.kernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
    ];

    kernelModules = [
      "kvm-intel"
      "coretemp"
    ];

    supportedFilesystems = ["ntfs"];

    tmp.cleanOnBoot = true;

  };

  systemd.coredump = {
    enable = true;
    settings.Coredump.MaxUse = "1G";
  };

  fileSystems."/" = {
    options = [
      "noatime"
      "commit=60"
    ];
  };

  # earlyoom is the oom killer; systemd-oomd watched no slices here
  services.earlyoom.enable = true;
  systemd.oomd.enable = false;
}
