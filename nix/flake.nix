{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # zen is installed by home-manager now (hm/flake.nix); this input only backs the
    # commented system install in modules/nixos/users/packages.nix
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
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
          inputs.sysc-greet.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ../hosts/${my.host}
        ];
      };
    };
  };
}
