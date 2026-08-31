{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  outputs = {
    self,
    nixpkgs,
    niri,
    ...
  } @ inputs: {
    nixosConfigurations = {
      mntbnd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          {nixpkgs.config.allowUnfree = true;}
          niri.nixosModules.niri
          ./configuration.nix
        ];
      };
    };
  };
}
