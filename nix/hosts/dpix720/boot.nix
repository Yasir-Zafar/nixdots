# hosts/dpix720/boot.nix
{ pkgs, ... }:

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
      "net.ipv4.tcp_rmem" = "4096 87380 8388608";
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_wmem" = "4096 87380 8388608";
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

  fileSystems."/".options = [ "noatime" "commit=60" ];

  # Boot performance tweaks
  systemd = {
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online.enable = false;
    };
  };
}
