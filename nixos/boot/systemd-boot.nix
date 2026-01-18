# nixos/boot/systemd-boot.nix
{pkgs, ...}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        # Use systemd-boot EFI boot loader
        enable = true;

        # Limit number of generations to keep boot partition clean
        configurationLimit = 10;
        editor = false;
      };
      timeout = 1;
    };

    # Kernel parameters for better performance and compatibility
    kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
      "mitigations=auto"
      "intel_iommu=on"
      "acpi_backlight=native"
      "pci=noaer"
      "snd-intel-dspcfg.dsp_driver=1"
      "i8042.nopnp"
      "nvme_core.default_ps_max_latency_us=5500"
    ];

    # Use latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;

    # Enable support for NTFS (for gaming/dual boot)
    supportedFilesystems = ["ntfs"];

    initrd.kernelModules = ["nvme" "xhci_pci" "ahci"];
    kernelModules = ["kvm-intel" "coretemp"];
  };

  virtualisation.libvirtd.enable = true;

  # File system optimizations
  fileSystems."/".options = ["noatime" "commit=60"];
}
