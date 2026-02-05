{
  config,
  pkgs,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true; # needed for Windows 11 TPM
      ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull];
      };
    };
  };

  programs.virt-manager.enable = true;
}
