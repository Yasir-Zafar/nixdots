{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true; # needed for Windows 11 TPM
    };
    allowedBridges = ["virbr0"];
  };

  virtualisation.waydroid.enable = true;

  hardware.opengl.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    spice
    spice-gtk
    spice-protocol
    virt-viewer
  ];
}
