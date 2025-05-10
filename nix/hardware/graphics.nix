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
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      vulkan-tools
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  
  # For Intel
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use intel-media-driver
    VDPAU_DRIVER = "va_gl";
    MOZ_X11_EGL = "1"; # For Firefox hardware acceleration
    MOZ_ACCELERATED = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
  
  # Graphics tools
  environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
    libva-utils
    vdpauinfo
    intel-gpu-tools # For Intel GPUs
  ];
}
