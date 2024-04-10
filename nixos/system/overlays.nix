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
      (import inputs.emacs-overlay)
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
}
