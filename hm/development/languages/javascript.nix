{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      nodejs

      nodePackages.typescript
      nodePackages.webpack-cli

      nodePackages.eslint
      nodePackages.prettier

      nodePackages.nodemon
      nodePackages.npm-check-updates
      ngrok
      postman
    ];

    sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    file.".npmrc".text = ''
      prefix=''${HOME}/.npm-global
      init-author-name=Your Name
      init-author-email=mntbnd720@proton.me
      init-license=MIT
      init-version=0.1.0
      engine-strict=false
      save-exact=true
    '';
  };
}
