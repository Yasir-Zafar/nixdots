# hosts/dpix720/boot.nix
{ config, lib, pkgs, ... }:

{
  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false; # Disable bootloader editing for security
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    
    # Silent boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    
    # Plymouth (boot splash)
    #plymouth = {
    #  enable = true;
    #  theme = "breeze";
    #};
    
    # Better kernel parameters for desktop
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "kernel.nmi_watchdog" = 0;
      "net.core.netdev_max_backlog" = 5000;
      "net.core.rmem_max" = 8388608;
      "net.core.wmem_max" = 8388608;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      # "net.ipv4.tcp_rmem" = "4096 87380 8388608";
      # "net.ipv4.tcp_slow_start_after_idle" = 0;
      # "net.ipv4.tcp_wmem" = "4096 87380 8388608";
    };
    
    # Enable crash handling
    crashDump.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Kernel modules to load early in the boot process
    initrd.kernelModules = [
      "vfat"
      "usbhid"
    ];
    
    # Better thermald support
    kernelModules = [ "kvm-intel" "coretemp" "acpi_thermal_rel" ];
    extraModulePackages = [ ];
    
    # Cleanup /tmp during boot
    tmp.cleanOnBoot = true;
  };

  # Boot performance tweaks
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
