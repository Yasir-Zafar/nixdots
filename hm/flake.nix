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

    # prebuilt nix-index database: `, <cmd>` (comma) and command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen browser through its home-manager module (policies + extensions as config)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # claude code, rebuilt hourly from anthropic's releases (nixpkgs lags behind)
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # encrypted secrets in the repo (secrets/secrets.yaml), decrypted at login
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    # self,
    nixpkgs,
    home-manager,
    niri,
    antigravity-nix,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      localSystem.system = "x86_64-linux";
      config.allowUnfree = true;
      # pkgs.claude-code comes from claude-code-nix instead of nixpkgs
      overlays = [inputs.claude-code.overlays.default];
    };
    antigravity = antigravity-nix.packages.x86_64-linux;
    my = import ../lib;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [alejandra statix deadnix nh];
    };

    homeConfigurations = {
      ${my.user} = home-manager.lib.homeManagerConfiguration {
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
          inputs.nix-index-database.homeModules.default
          ../home/${my.user}.nix
        ];

        extraSpecialArgs = {
          inherit inputs my;
        };
      };
    };
  };
}
