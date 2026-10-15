# VS Code, declared: extensions, settings and update behaviour all live here.
# Extensions come from nixpkgs wherever it has them (patched for NixOS, cached); the few it
# lacks come from the marketplace through nix-vscode-extensions (hm/flake.nix), pinned by
# flake.lock and bumped with `nx update`. The extensions folder is read-only: add or drop
# an extension here, not in the UI. Settings are merged into settings.json on every
# switch (declared keys win; the UI can still change anything not listed).
{
  config,
  pkgs,
  inputs,
  ...
}: let
  market = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace-release;
  ext = pkgs.vscode-extensions;
  mono = config.stylix.fonts.monospace.name;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;

    profiles.default = {
      # Nix manages updates
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableUserSettings = true;

      extensions = [
        # look
        ext.jdinhlife.gruvbox
        market.jonathanharty.gruvbox-material-icon-theme

        # AI
        ext.anthropic.claude-code

        # nix and environments
        ext.jnoortheen.nix-ide
        ext.mkhl.direnv

        # git
        ext.eamodio.gitlens
        ext.github.vscode-pull-request-github
        ext.github.vscode-github-actions

        # python (python pulls in debugpy, pylance and python-envs)
        ext.ms-python.python
        ext.ms-python.debugpy
        ext.ms-python.vscode-pylance
        ext.ms-python.vscode-python-envs
        ext.charliermarsh.ruff
        ext.njpwerner.autodocstring
        ext.ms-toolsai.jupyter
        ext.ms-toolsai.jupyter-keymap
        ext.ms-toolsai.jupyter-renderers
        ext.ms-toolsai.vscode-jupyter-cell-tags
        ext.ms-toolsai.vscode-jupyter-slideshow

        # web
        ext.dbaeumer.vscode-eslint
        ext.esbenp.prettier-vscode
        ext.graphql.vscode-graphql
        ext.graphql.vscode-graphql-syntax

        # c / build
        ext.ms-vscode.makefile-tools

        # containers
        ext.ms-azuretools.vscode-containers
        ext.ms-azuretools.vscode-docker

        # data
        market.cweijan.vscode-postgresql-client2
        market.chuckjonas.duckdb
        ext.mechatroner.rainbow-csv

        # editing quality of life
        ext.usernamehw.errorlens
        ext.gruntfuggly.todo-tree
        ext.tamasfe.even-better-toml
        ext.yzhang.markdown-all-in-one
        ext.mikestead.dotenv
      ];

      userSettings = {
        # --- look ---
        "workbench.colorTheme" = "Gruvbox Dark Medium";
        "workbench.iconTheme" = "gruvbox-material-icon-theme";
        "editor.fontFamily" = "'${mono}', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'${mono}'";
        "editor.minimap.enabled" = false;
        "editor.stickyScroll.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.smoothScrolling" = true;
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "workbench.startupEditor" = "none";
        "workbench.tips.enabled" = false;

        # --- editing ---
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {"source.fixAll" = "explicit";};
        "editor.renderWhitespace" = "trailing";
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "terminal.integrated.defaultProfile.linux" = "fish";

        # --- git ---
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.pruneOnFetch" = true;
        "git.openRepositoryInParentFolders" = "always";

        # --- no telemetry; updates come from nix ---
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;

        # --- per language: who formats ---
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.tabSize" = 2;
        };
        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.codeActionsOnSave" = {
            "source.fixAll" = "explicit";
            "source.organizeImports" = "explicit";
          };
        };
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
        "[markdown]" = {
          "editor.wordWrap" = "on";
          "files.trimTrailingWhitespace" = false; # two trailing spaces are a line break
        };

        # --- extensions ---
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings".nil.formatting.command = ["alejandra"];
        "direnv.restart.automatic" = true;
        "claudeCode.preferredLocation" = "panel";
        "todo-tree.ripgrep.ripgrep" = "${pkgs.ripgrep}/bin/rg";
      };
    };
  };
}
