{pkgs, ...}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = true;
      };

      timeout = 1;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "mitigations=auto"
      "intel_iommu=on"
      "kvm-intel.nested=1"
      "acpi_osi=Linux"
      "acpi_backlight=native"
      "snd-intel-dspcfg.dsp_driver=1"
      "i8042.nopnp"
      "nvme_core.default_ps_max_latency_us=5500"
    ];

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

  systemd.coredump.enable = false;

  fileSystems."/" = {
    options = [
      "noatime"
      "commit=60"
    ];
  };

  services.earlyoom.enable = true;
}
