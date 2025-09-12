{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      mntbnd = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = {
	  inherit inputs;
	  pkgs = import nixpkgs {
	    system = "x86_64-linux";
	    config.allowUnfree = true;
	  };
	};
	modules = [
	  ./configuration.nix
	  ./hardware-configuration.nix
	];
      };
    };
  };
}
