{
  config,
  pkgs,
  lib,
  ...
}: 
let
  # Path to your existing Neovim config folder
  # Update this to your actual config path
  nvimConfigPath = "~/Dotfiles/config/nvim";
  
  # Create a copy of the lazy-lock.json that won't be managed by Home Manager
  # This allows modifications to lazy-lock.json without conflicts
  nvimLazyLockScript = pkgs.writeShellScriptBin "nvim-lazy-lock-fix" ''
    # Create necessary directories
    mkdir -p ~/.config/nvim

    # Check if we need to initialize the lazy-lock.json
    if [ ! -f ~/.config/nvim/lazy-lock.json ]; then
      # If original exists, copy it as initial version
      if [ -f ${nvimConfigPath}/lazy-lock.json ]; then
        cp ${nvimConfigPath}/lazy-lock.json ~/.config/nvim/lazy-lock.json
      else
        # Create empty file if no original exists
        echo '{}' > ~/.config/nvim/lazy-lock.json
      fi
    fi

    # Make sure lazy-lock.json is writable
    chmod u+w ~/.config/nvim/lazy-lock.json
  '';
in {
  # Install Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # We're using a custom config, so we don't need these
    # but you can add Neovim plugins from nixpkgs if needed
    plugins = [ ];
  };

  # Add our script to home packages
  home.packages = with pkgs; [
    nvimLazyLockScript
    # Dependencies your neovim config might need
    nodePackages.neovim
    nodePackages.tree-sitter-cli
    ripgrep
    fd
    lua-language-server
  ];

  # Copy over your existing Neovim configuration
  # But exclude the lazy-lock.json file
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
      recursive = true;
      # Exclude lazy-lock.json since we'll handle it separately
      # This pattern means "include everything except lazy-lock.json"
      exclude = [ "lazy-lock.json" ];
    };
  };

  # Run the script to set up lazy-lock.json during activation
  home.activation.setupNeovimLazyLock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${nvimLazyLockScript}/bin/nvim-lazy-lock-fix
  '';
}
