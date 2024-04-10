{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      verbose = true;
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ ];
    };

    blacklistedKernelModules = [ "nouveau" "nvidia" "amd" ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "quiet" "udev.log_level=3" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/78e38f56-16a7-4c2f-9dc1-2d94c869641a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/22A2-E15F";
    fsType = "vfat";
  };

  fileSystems."/home/boi/Data" = {
    device = "/dev/disk/by-uuid/6115df94-b039-46d3-8e72-026203e36ae1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
