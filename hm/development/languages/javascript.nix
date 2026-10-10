{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      nodejs

      typescript
      eslint
      prettier
      nodemon
      npm-check-updates
      ngrok
      postman
      nginx
    ];

    # ~/.npm-global/bin is on PATH via shell/environment.nix
    sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    file.".npmrc".text = ''
      prefix=''${HOME}/.npm-global
      init-author-email=mntbnd720@proton.me
      init-license=MIT
      init-version=0.1.0
      engine-strict=false
      save-exact=true
    '';
  };
}
