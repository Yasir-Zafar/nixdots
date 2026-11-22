{pkgs, ...}: {
  # early KMS: the display driver starts in the initrd, so the screen keeps one mode
  # from boot to greeter (no flicker / mode switch when the real driver would load)
  boot.initrd.kernelModules = ["i915"];

  # xe instead of i915: tried 2026-11-23 and dropped the same day. The Arrow Lake iGPU
  # (8086:7d41) only runs on xe through force_probe; video decode, vulkan and idle power
  # were fine, but Noctalia was killed by a Wayland protocol error (code 6) whenever it
  # opened a small popup (volume/media OSD). To try again: "xe" in the initrd above and
  # boot.kernelParams = [
  #   "i915.force_probe=!7d41" # stop i915 from taking the GPU first
  #   "xe.force_probe=7d41"
  # ];

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
