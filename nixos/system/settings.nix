{ inputs, lib, config, ... }:{
  nixpkgs = {

    config = {

      allowUnfree = true;

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

    };

  };

}
