{inputs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    # pin `nix shell nixpkgs#foo` and <nixpkgs> to the system's nixpkgs
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}
