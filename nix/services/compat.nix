# running non-nix binaries
{pkgs, ...}: {
  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [pkgs.libxshmfence pkgs.zstd];
    };
  };
}
