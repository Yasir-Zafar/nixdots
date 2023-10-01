{

  description = "Yasir's NixOS flake";

  nixConfig = {

    experimental-features = [ "nix-command" "flakes" ];
    substituters = [

      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"

    ];

    extra-substituters = [

      "https://nix-community.cachix.org"

    ];

    extra-trusted-public-keys = [

      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

    ];

  };

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs = { self, nixpkgs, ... }@inputs: {
  
    nixosConfigurations = {

      dpix = nixpkgs.lib.nixosSystem {

	specialArgs = { inherit inputs; };
	modules = [

	  ./default.nix

	];

      };

    };

  };

}

