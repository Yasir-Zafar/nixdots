# flake.nix
# Main NixOS flake configuration
{
  description = "NixOS system configuration";

  # ============================================================================
  # Inputs - External dependencies
  # ============================================================================
  inputs = {
    # Use unstable channel for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Zen Browser (privacy-focused Firefox fork)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };
  };

  # ============================================================================
  # Outputs - System configurations
  # ============================================================================
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # System hostname: mntbnd
      mntbnd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Make inputs available to all modules
        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Enable unfree packages globally
          {
            nixpkgs.config.allowUnfree = true;
          }

          # Main configuration entry point
          ./configuration.nix
        ];
      };
    };
  };
}
