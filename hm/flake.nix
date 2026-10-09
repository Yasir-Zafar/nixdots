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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    niri,
    antigravity-nix,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      localSystem.system = "x86_64-linux";
      config.allowUnfree = true;
    };
    antigravity = antigravity-nix.packages.x86_64-linux;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [alejandra statix deadnix nh];
    };

    homeConfigurations = {
      boi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home.packages = [
              antigravity.default
              antigravity.google-antigravity-ide
              antigravity.google-antigravity-cli
            ];
          }
          # {
          #   nixpkgs.overlays = [
          #     (final: prev: {
          #       dwarfs = prev.dwarfs.override {boost = prev.boost188;};
          #     })
          #   ];
          # }
          niri.homeModules.niri
          inputs.nixcord.homeModules.nixcord
          inputs.stylix.homeModules.stylix
          ./home.nix
        ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
