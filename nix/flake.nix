{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # zen: installed by home-manager now; uncomment with users/packages.nix to go back
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake/beta";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    niri = {
      url = "github:epireyn/niri-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mango (dwl-based tiling compositor): session + portals; config is in hm/
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pinned: later revs are unfree (cc-by-nc), and my allowUnfree can't reach the module's pkgs
    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet/4c98abc5bdddbf6c84d2a55d71b9120cbfccad0f";
      inputs.nixpkgs.follows = "nixpkgs";
      # shares mango's copy of flake-utils (same commit)
      inputs.flake-utils.follows = "mango/scenefx/flake-utils";
    };

    # flatpaks as config (Sober); see modules/nixos/desktop/flatpak.nix
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  outputs = {
    nixpkgs,
    niri,
    ...
  } @ inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    my = import ../lib;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [alejandra statix deadnix nh];
    };

    # per-project dev shells: `nix flake init -t ~/dots/nix#rust`, then `direnv allow`
    templates = {
      rust = {
        path = ../templates/rust;
        description = "rust: cargo, clippy, rust-analyzer, bacon, openssl";
      };
      python = {
        path = ../templates/python;
        description = "python: uv-managed .venv on nix's python, ruff, basedpyright";
      };
      node = {
        path = ../templates/node;
        description = "node: nodejs, pnpm, typescript + language server";
      };
      c = {
        path = ../templates/c;
        description = "c/c++: clang stdenv, cmake, meson, ninja, lldb";
      };
    };

    nixosConfigurations = {
      ${my.host} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs my;
        };

        modules = [
          niri.nixosModules.niri
          inputs.mango.nixosModules.mango
          inputs.sysc-greet.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ../hosts/${my.host}
        ];
      };
    };
  };
}
