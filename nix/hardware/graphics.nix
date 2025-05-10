# hardware/graphics.nix
{ config, lib, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # LIBVA_DRIVER_NAME=iHD
      vaapiIntel          # LIBVA_DRIVER_NAME=i965 (older but works better for some applications)
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (Intel)
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  
  # Configure GPU-specific settings
  # Uncomment the section that matches your GPU
  
  # For Intel
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use intel-media-driver
    VDPAU_DRIVER = "va_gl";
    MOZ_X11_EGL = "1"; # For Firefox hardware acceleration
    MOZ_ACCELERATED = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
  
  /*
  # For NVIDIA
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      # If you have Optimus:
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  }; 
  */
  
  /*
  # For AMD
  hardware.amdgpu = {
    opencl = true;
    amdvlk = true;
  };
  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    AMD_VULKAN_ICD = "RADV";
    MOZ_X11_EGL = "1"; # For Firefox hardware acceleration
    MOZ_ACCELERATED = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
  */
  
  # Vulkan support
  hardware.opengl.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-tools
    intel-media-driver
  ];
  
  # Graphics tools
  environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
    libva-utils
    vdpauinfo
    intel-gpu-tools # For Intel GPUs
    # nvidia-offload # Uncomment for NVIDIA
    # radeontop    # Uncomment for AMD
  ];
}
