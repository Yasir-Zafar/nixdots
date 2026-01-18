# nixos/hardware/intel-graphics.nix
# Intel integrated graphics configuration
{pkgs, ...}: {
  # ============================================================================
  # Intel Graphics Drivers
  # ============================================================================
  hardware.graphics = {
    enable = true;

    # Graphics packages and hardware acceleration libraries
    extraPackages = with pkgs; [
      # VA-API (Video Acceleration API) drivers
      intel-media-driver # iHD driver - Gen 8+ (Broadwell, Skylake, etc.)
      intel-vaapi-driver # i965 driver - older GPUs, sometimes more stable

      # VDPAU (Video Decode and Presentation API)
      libva-vdpau-driver # VDPAU support via VA-API

      # Vulkan support
      vulkan-loader # Vulkan ICD loader
      vulkan-validation-layers # Vulkan debugging layers
      vulkan-extension-layer # Additional Vulkan extensions
      vulkan-tools # Vulkan utilities (vulkaninfo, etc.)

      # Optional: OpenCL support for compute tasks
      # intel-compute-runtime                           # OpenCL runtime for Intel GPUs
    ];
  };

  # ============================================================================
  # Intel GPU Utilities
  # ============================================================================
  environment.systemPackages = with pkgs; [
    intel-gpu-tools # Intel GPU debugging tools (intel_gpu_top)
    mesa-demos # OpenGL test utilities (glxinfo, glxgears)
    vulkan-tools # Vulkan info and test tools
    libva-utils # VA-API utilities (vainfo)
    vdpauinfo # VDPAU info tool
  ];

  # ============================================================================
  # Graphics Environment Variables
  # ============================================================================
  environment.sessionVariables = {
    # VA-API driver selection
    # Use "iHD" for Gen 8+ (Broadwell and newer)
    # Use "i965" for older GPUs or if you experience issues with iHD
    LIBVA_DRIVER_NAME = "iHD";

    # VDPAU backend (use VA-API for VDPAU)
    VDPAU_DRIVER = "va_gl";

    # Firefox hardware acceleration
    MOZ_ACCELERATED = "1";

    # Optional: Force specific Vulkan ICD
    # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };

  # ============================================================================
  # Kernel Modules & Boot Parameters
  # ============================================================================
  # Optional: Intel GPU-specific kernel parameters (add to boot config if needed)
  # boot.kernelParams = [
  #   "i915.enable_guc=2"                               # GuC/HuC firmware loading (newer GPUs)
  #   "i915.fastboot=1"                                 # Keep display configuration from boot
  # ];
}
