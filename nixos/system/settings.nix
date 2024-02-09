{ inputs, lib, config, ... }:{
  nixpkgs = {

    config = {

      allowUnfree = true;

      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
      ];

    };

  };

  nix = {

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc.automatic = true;

    settings = {

      trusted-users = [ "boi" ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

    };

  };

}
