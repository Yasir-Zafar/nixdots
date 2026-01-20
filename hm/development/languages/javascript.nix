# ============================================================================
# JavaScript/Node.js Development Environment
# Location: hm/development/languages/javascript.nix
# ============================================================================
{pkgs, ...}: {
  home = {
    # ========================================================================
    # JAVASCRIPT PACKAGES
    # ========================================================================
    packages = with pkgs; [
      # ------------------------------------------------------------------------
      # Node.js Runtime & Package Managers
      # ------------------------------------------------------------------------
      nodejs # Node.js runtime (LTS version)
      # nodejs_18 # Alternative: Node.js 18 LTS
      # nodejs_20 # Alternative: Node.js 20 LTS

      yarn # Fast, reliable package manager
      pnpm # Fast, disk space efficient package manager
      bun # Modern JavaScript runtime (optional)

      # ------------------------------------------------------------------------
      # TypeScript & Build Tools
      # ------------------------------------------------------------------------
      nodePackages.typescript # TypeScript compiler
      nodePackages.webpack-cli # Module bundler

      # ------------------------------------------------------------------------
      # Code Quality Tools
      # ------------------------------------------------------------------------
      nodePackages.eslint # JavaScript linter
      nodePackages.prettier # Code formatter

      # ------------------------------------------------------------------------
      # Development Tools
      # ------------------------------------------------------------------------
      nodePackages.nodemon # Auto-restart on file changes
      nodePackages.npm-check-updates # Update package versions

      # ------------------------------------------------------------------------
      # Framework CLIs (Uncomment as needed)
      # ------------------------------------------------------------------------
      # nodePackages.vite # Fast build tool
      # nodePackages."@angular/cli" # Angular CLI
      # nodePackages.create-react-app # React project generator
      # nodePackages.vue-cli # Vue.js CLI
    ];

    # ========================================================================
    # NPM CONFIGURATION
    # ========================================================================
    sessionVariables = {
      # npm global packages directory (avoid sudo for global installs)
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    # Add npm global bin to PATH
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    # npm configuration file
    file.".npmrc".text = ''
      # Global package installation directory
      prefix=''${HOME}/.npm-global

      # Package initialization defaults
      init-author-name=Your Name
      init-author-email=mntbnd720@proton.me
      init-license=MIT
      init-version=0.1.0

      # Performance optimizations
      engine-strict=false
      save-exact=true

      # Optional: Use pnpm for faster installs
      # package-lock=false

      # Optional: Registry configuration
      # registry=https://registry.npmjs.org/
    '';

    # ========================================================================
    # PNPM CONFIGURATION (Optional)
    # ========================================================================
    # file.".config/pnpm/rc".text = ''
    #   store-dir=$HOME/.pnpm-store
    #   global-bin-dir=$HOME/.pnpm-global/bin
    # '';

    # ========================================================================
    # YARN CONFIGURATION (Optional)
    # ========================================================================
    # file.".yarnrc".text = ''
    #   # Yarn v1 configuration
    #   prefix "$HOME/.yarn-global"
    # '';
  };
}
# ============================================================================
# NODE VERSION MANAGEMENT
# ============================================================================
# To use multiple Node.js versions:
#
# 1. With nix-shell per project:
#    nix-shell -p nodejs_18
#
# 2. With direnv (.envrc in project):
#    use nix -p nodejs_18
#
# 3. With flakes (in project flake.nix):
#    devShells.default = pkgs.mkShell {
#      packages = [ pkgs.nodejs_18 ];
#    };
# ============================================================================
# ============================================================================
# ADDITIONAL JAVASCRIPT TOOLS TO CONSIDER
# ============================================================================
# Package managers:
# - bun: Modern all-in-one JavaScript runtime
#
# Build tools:
# - esbuild: Fast JavaScript bundler
# - rollup: Module bundler
# - parcel: Zero-config bundler
#
# Testing:
# - nodePackages.jest: JavaScript testing framework
# - nodePackages.mocha: Test framework
# - playwright: End-to-end testing
#
# Development:
# - nodePackages.live-server: Live reload server
# - nodePackages.http-server: Simple HTTP server
# ============================================================================

