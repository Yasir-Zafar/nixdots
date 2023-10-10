{ self, inputs, ... }:{

  nixpkgs = {

    overlays = [

      (import inputs.emacs-overlay)
      (import inputs.nix-matlab.overlay)

    ];
  };

}
