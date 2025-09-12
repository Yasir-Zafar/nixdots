{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    homeConfigurations = {
      boi = home-manager.lib.homeManagerConfiguration {
	pkgs = import nixpkgs {
	  system = "x86_64-linux";
	  config.allowUnfree = true;
	};
	modules = [
	  ./home.nix
	];
      };
    };
  };
}
