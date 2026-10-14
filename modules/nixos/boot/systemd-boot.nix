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

    # Testing a change safely: never edit this list first. At the boot menu press `e` on
    # the newest entry, add/remove the param, boot once, and check what it affects
    # (sound, mic, keyboard/touchpad, brightness, `cat /proc/cmdline`). The edit is
    # gone on the next boot. Only move it here once it worked, then `nx os boot` and
    # reboot; the previous generation stays in the menu as the way back.
    kernelParams = [
      # quiet boot (the console log level itself is boot.consoleLogLevel below: a
      # "loglevel=3" here was overridden by the loglevel=4 nixos appends after it)
      "quiet"
      "udev.log_level=3"

      # NOT a default on this kernel (CONFIG_INTEL_IOMMU_DEFAULT_ON is not set): keeps
      # the Intel IOMMU on (DMA protection, device passthrough for VMs)
      "intel_iommu=on"
      # removed: "mitigations=auto" is already the kernel default (CONFIG_CPU_MITIGATIONS=y)

      # nested virtualisation for VMs inside VMs (harmless if unused)
      "kvm-intel.nested=1"

      "acpi_backlight=native" # only intel_backlight exists; keeps it that way
      "i8042.nopnp" # keyboard/touchpad controller probing

      # Removed 2026-10-15 (at my request, without a test boot first). If something
      # below breaks, press `e` at the boot menu, add the param back for one boot to
      # confirm, then restore it here:
      #   "acpi_osi=Linux"  old firmware workaround. Symptoms if needed: odd fan,
      #                     thermal or brightness behaviour, missing hotkeys
      #   "snd-intel-dspcfg.dsp_driver=1"  forced legacy HDA audio. Without it the SOF
      #                     driver runs, which also drives the built-in digital mics
      #                     (firmware ships them). Symptom if needed: no sound at all
      #   "nvme_core.default_ps_max_latency_us=5500"  kept the SSD out of its deepest
      #                     power state. Symptoms if needed: nvme timeouts/resets in
      #                     `journalctl -k`, hangs after suspend
    ];

    # already in hardware-configuration.nix's availableKernelModules (ahci is for SATA,
    # this laptop is NVMe only); harmless, left as is
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

    # systemd in the initrd and dbus-broker are already nixos defaults (checked with
    # nix eval), so there is nothing to switch on here
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

  # earlyoom is the oom killer here. systemd-oomd (on by default) watches no slices in
  # this config, so it only ran idle next to it
  services.earlyoom.enable = true;
  systemd.oomd.enable = false;
}
