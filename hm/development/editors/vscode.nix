# ============================================================================
# Visual Studio Code Configuration
# Location: hm/development/editors/vscode.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # VSCODE PACKAGE
  # ==========================================================================
  home.packages = with pkgs; [
    vscode # Visual Studio Code
    # vscode-fhs # Alternative: VSCode with FHS environment for better extension compatibility
  ];

  # ==========================================================================
  # DECLARATIVE VSCODE CONFIGURATION (Optional)
  # ==========================================================================
  # Uncomment to manage VSCode settings declaratively
  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode;
  #
  #   # User settings
  #   userSettings = {
  #     # Editor
  #     "editor.fontSize" = 14;
  #     "editor.fontFamily" = "JetBrains Mono, monospace";
  #     "editor.fontLigatures" = true;
  #     "editor.lineNumbers" = "relative";
  #     "editor.minimap.enabled" = false;
  #     "editor.rulers" = [80, 120];
  #     "editor.tabSize" = 2;
  #
  #     # Workbench
  #     "workbench.colorTheme" = "Gruvbox Dark Hard";
  #     "workbench.iconTheme" = "material-icon-theme";
  #     "workbench.startupEditor" = "none";
  #
  #     # Files
  #     "files.autoSave" = "afterDelay";
  #     "files.trimTrailingWhitespace" = true;
  #     "files.insertFinalNewline" = true;
  #
  #     # Terminal
  #     "terminal.integrated.fontSize" = 13;
  #     "terminal.integrated.fontFamily" = "JetBrains Mono";
  #
  #     # Git
  #     "git.autofetch" = true;
  #     "git.confirmSync" = false;
  #
  #     # Language-specific
  #     "[nix]"."editor.tabSize" = 2;
  #     "[python]"."editor.tabSize" = 4;
  #     "[javascript]"."editor.tabSize" = 2;
  #   };
  #
  #   # Extensions
  #   extensions = with pkgs.vscode-extensions; [
  #     # Themes
  #     jdinhlife.gruvbox
  #     pkief.material-icon-theme
  #
  #     # Languages
  #     jnoortheen.nix-ide # Nix language support
  #     ms-python.python # Python
  #     ms-vscode.cpptools # C/C++
  #     rust-lang.rust-analyzer # Rust
  #
  #     # Tools
  #     eamodio.gitlens # Enhanced Git
  #     vscodevim.vim # Vim keybindings
  #     editorconfig.editorconfig # EditorConfig support
  #
  #     # Formatters
  #     esbenp.prettier-vscode # Prettier
  #     ms-vscode.makefile-tools # Makefile support
  #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #     # Add extensions not in nixpkgs
  #     # {
  #     #   name = "extension-name";
  #     #   publisher = "publisher-name";
  #     #   version = "1.0.0";
  #     #   sha256 = "sha256-hash";
  #     # }
  #   ];
  # };
}
