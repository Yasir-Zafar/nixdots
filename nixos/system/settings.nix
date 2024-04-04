{
  inputs,
  lib,
  config,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;

      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-run"
        ];
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc.automatic = true;

    settings = {
      trusted-users = ["boi"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
        "https://cache.nixos.org/"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://bbigras-nix-config.cachix.org"
      ];

      extra-trusted-public-keys = [
        "bbigras-nix-config.cachix.org-1:aXL6Q9Oi0jyF79YAKRu17iVNk9HY0p23OZX7FA8ulhU="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
