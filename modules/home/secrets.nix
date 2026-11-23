# sops-nix: secrets/secrets.yaml decrypted at login into RAM. Age key (not in repo, back it up):
# ~/.config/sops/age/keys.txt. Edit: sops ~/dots/secrets/secrets.yaml
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
      # unused by config, recorded only (Thunderbird keeps the account)
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
