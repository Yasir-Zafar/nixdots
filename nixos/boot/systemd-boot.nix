# nixos/boot/systemd-boot.nix
{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      # Use systemd-boot EFI boot loader
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Limit number of generations to keep boot partition clean
      systemd-boot.configurationLimit = 10;
    };

    # Kernel parameters for better performance and compatibility
    kernelParams = [
      "quiet"
      "splash"
    ];

    # Use latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    # Enable support for NTFS (for gaming/dual boot)
    supportedFilesystems = ["ntfs"];
  };
}
