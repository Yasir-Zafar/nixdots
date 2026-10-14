{pkgs, ...}: {
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver # VA-API (iHD)
      libvdpau-va-gl # VDPAU on top of VA-API, matches VDPAU_DRIVER below
      vpl-gpu-rt # Quick Sync (oneVPL) for Arrow Lake: ffmpeg/obs qsv encoders
      intel-compute-runtime # OpenCL / Level Zero (blender, darktable…)
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    mesa-demos
    vulkan-tools
    libva-utils
    vdpauinfo
  ];

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    MOZ_ACCELERATED = "1";
  };
}
