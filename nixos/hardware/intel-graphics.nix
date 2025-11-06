# nixos/hardware/intel-graphics.nix
{
  config,
  pkgs,
  ...
}: {
  # Intel graphics drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but sometimes more stable)
      libva-vdpau-driver
      # intel-compute-runtime # OpenCL support

      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      vulkan-tools
    ];
  };

  # Intel GPU tools
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    mesa-demos
    vulkan-tools
    libva-utils
    vdpauinfo
  ];

  # Environment variables for Intel graphics
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # or "i965" if you have issues
    VDPAU_DRIVER = "va_gl";
    MOZ_ACCELERATED = "1";
  };
}
