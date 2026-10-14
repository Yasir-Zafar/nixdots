{
  description = "python project (uv manages the venv and packages)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [python3 uv ruff basedpyright];
      # uv uses nix's python instead of downloading its own
      UV_PYTHON_DOWNLOADS = "never";
      UV_PYTHON = "${pkgs.python3}/bin/python3";
      shellHook = ''
        [ -d .venv ] || uv venv --quiet
        source .venv/bin/activate
      '';
    };
  };
}
