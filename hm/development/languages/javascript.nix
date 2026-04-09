{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs

    typescript
    eslint
    prettier
    nodemon
    npm-check-updates
    ngrok
    postman
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
    init-author-email=mntbnd720@proton.me
    init-license=MIT
    init-version=0.1.0
    engine-strict=false
    save-exact=true
  '';
}
