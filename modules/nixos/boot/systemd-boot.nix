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

      # hardware workarounds. Candidates to re-test one at a time with the boot editor:
      # acpi_osi=Linux is an old workaround that modern firmware usually doesn't want;
      # dsp_driver=1 forces the legacy HDA audio driver instead of SOF (Core Ultra
      # laptops often need SOF for the built-in mic: if the mic works now, keep it);
      # the nvme cap keeps the SSD out of its deepest power state (costs some battery,
      # only needed if the drive has resume problems).
      "acpi_osi=Linux"
      "acpi_backlight=native"
      "snd-intel-dspcfg.dsp_driver=1"
      "i8042.nopnp" # keyboard/touchpad controller probing
      "nvme_core.default_ps_max_latency_us=5500"
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
