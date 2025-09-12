{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs: {
    homeConfigurations = {
      boi = home-manager.lib.homeManagerConfiguration {
	pkgs = import nixpkgs {
	  system = "x86_64-linux";
	  config.allowUnfree = true;
	};
	modules = [
	  ./home.nix
	  {
            _module.args = {
              inherit inputs;
            };
	  }
	];
        extraSpecialArgs = {
          inherit inputs;
      };
    };
  };
}
