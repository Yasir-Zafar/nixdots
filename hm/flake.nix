{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs"; # This unifies the LuaJIT versions
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    niri,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      localSystem.system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in {
    homeConfigurations = {
      boi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          # {
          #   nixpkgs.overlays = [
          #     (final: prev: {
          #       dwarfs = prev.dwarfs.override {boost = prev.boost188;};
          #     })
          #   ];
          # }
          niri.homeModules.niri
          ./home.nix
        ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
