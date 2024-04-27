{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      #(self: super: { discord = super.discord.overrideAttrs (_: { src = builtins.fetchTarball <link-to-tarball>; });})
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
}
