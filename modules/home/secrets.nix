# Secrets with sops-nix. secrets/secrets.yaml is encrypted in the repo; it's decrypted
# at login by the `sops-nix` user service with the age key below, into
# $XDG_RUNTIME_DIR/secrets.d (RAM only), linked from ~/.config/sops-nix/secrets.
#
# The private key is NOT in the repo: ~/.config/sops/age/keys.txt. Back it up
# (password manager / USB). Without it the secrets can't be decrypted.
# Edit secrets with:  sops ~/dots/secrets/secrets.yaml
{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      git_email = {};
      # not consumed by any config: the thunderbird account keeps it in its profile.
      # Kept here so the address is recorded somewhere (see communication.nix)
      proton_address = {};
    };

    # git's identity, written at login; programs.git includes it (tools/git.nix)
    templates."git-identity".content = ''
      [user]
        email = ${config.sops.placeholder.git_email}
    '';
  };

  # `sops` to edit secrets/secrets.yaml, `age` for keys
  home.packages = [pkgs.sops pkgs.age];
}
