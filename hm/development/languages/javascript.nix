# hm/development/languages/javascript.nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    # JavaScript/Node.js development packages
    packages = with pkgs; [
      # Node.js and package managers
      nodejs
      yarn
      pnpm

      # Development tools
      nodePackages.typescript
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.nodemon

      # Build tools
      nodePackages.webpack-cli
    ];

    # npm global packages directory
    sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    # Add npm global bin to PATH
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    # npm configuration
    file.".npmrc".text = ''
      prefix=''${HOME}/.npm-global
      init-author-name=Your Name
      init-author-email=mntbnd720@proton.me
      init-license=MIT
    '';
  };
}
