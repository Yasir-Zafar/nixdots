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
      # the *.follows lines below without nixpkgs only share one copy of a helper flake
      # that two inputs had locked at the same commit (fewer fetches and lock nodes)
      inputs.flake-parts.follows = "nixvim/flake-parts";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mango's home-manager module: ~/.config/mango/config.conf, validated at build time
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      # declared but unused by its outputs; it pulled a second home-manager (release-26.05)
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "mango/flake-parts";
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

    # helium browser (chromium-based): not in nixpkgs yet. Repackages upstream's .deb; its home
    # module adds launch flags. Policies are system-side (modules/nixos/desktop/helium.nix)
    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # claude code, rebuilt hourly from anthropic's releases (nixpkgs lags behind)
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "nixvim/systems";
    };

    # encrypted secrets in the repo (secrets/secrets.yaml), decrypted at login
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "mango/scenefx/flake-utils";
    };

    # VS Code extensions that nixpkgs doesn't ship (programs.vscode in
    # modules/home/development/editors/vscode.nix); nixpkgs is used wherever it has them
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
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
      # pkgs.claude-code comes from claude-code-nix instead of nixpkgs; ../pkgs adds our own
      overlays = [inputs.claude-code.overlays.default (import ../pkgs)];
    };
    antigravity = antigravity-nix.packages.x86_64-linux;
    my = import ../lib;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    # `nix flake check ./hm`: nix doesn't know homeConfigurations, so without this a home that
    # no longer evaluates (renamed option, removed package) still passed. Only evaluates the
    # home (its .drv path is written to a file); nothing of the home is built.
    # The system side needs no such check: `nix flake check ./nix` evaluates nixosConfigurations.
    checks.x86_64-linux.home-evaluates = pkgs.writeText "home-evaluates" (
      builtins.unsafeDiscardStringContext inputs.self.homeConfigurations.${my.user}.activationPackage.drvPath
    );

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
          inputs.mango.hmModules.mango
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
