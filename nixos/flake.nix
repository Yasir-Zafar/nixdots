{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
	];
      };
    };
  };
}
