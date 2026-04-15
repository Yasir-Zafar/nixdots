{
  config,
  pkgs,
  ...
}: {
  programs = {
    fish = {
      enable = true;

      # --------------------------------------------------------------- #
      # SHELL INIT                                                        #
      # runs in every interactive shell                                   #
      # --------------------------------------------------------------- #
      interactiveShellInit = ''
        # disable greeting
        set -g fish_greeting

        # vi key bindings
        fish_default_key_bindings

        # pure prompt — single line, gruvbox colors
        set -g pure_prompt_single_line          true
        set -g pure_show_system_time            false
        set -g pure_show_jobs                   false
        set -g pure_color_primary               brblue
        set -g pure_color_success               brgreen
        set -g pure_color_error                 brred
        set -g pure_color_info                  bryellow
        set -g pure_color_mute                  brblack
        set -g pure_color_git_branch            green
        set -g pure_color_git_dirty             yellow
        set -g pure_color_git_unpulled_commits  yellow
        set -g pure_color_git_unpushed_commits  yellow
        set -g pure_symbol_prompt               "❯"
        set -g pure_symbol_reverse_prompt       "❮"
        set -g pure_symbol_git_dirty            "*"

        # Syntax Highlighting Colors
        set -g fish_color_normal ebdbb2
        set -g fish_color_command b8bb26
        set -g fish_color_quote d3869b
        set -g fish_color_redirection d65d0e
        set -g fish_color_end ffab10
        set -g fish_color_error fb4934
        set -g fish_color_param 83a598
        set -g fish_color_comment 928374
        set -g fish_color_match --background=brblue
        set -g fish_color_selection white --bold --background=brblack
        set -g fish_color_search_match bryellow --background=brblack
        set -g fish_color_history_current --bold
        set -g fish_color_operator 00a6b2
        set -g fish_color_escape 00a6b2
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_valid_path --underline

        # sponge: don't clean history on startup, only on exit
        set -g sponge_purge_only_on_exit true

        # done: notify only for commands taking longer than 10s
        set -g __done_min_cmd_duration 10000
      '';

      # aliases come from aliases.nix (shared + fish overrides)

      # --------------------------------------------------------------- #
      # FUNCTIONS                                                         #
      # --------------------------------------------------------------- #
      functions = {
        mkcd = {
          description = "mkdir and cd";
          body = ''
            if test -z "$argv[1]"
              echo "Usage: mkcd <dir>"
              return 1
            end
            mkdir -p $argv[1]; and cd $argv[1]
          '';
        };

        extract = {
          description = "extract common archive formats";
          body = ''
            if test -z "$argv[1]"
              echo "Usage: extract <archive>"
              return 1
            end
            if not test -f "$argv[1]"
              echo "Not a file: $argv[1]"
              return 1
            end
            switch $argv[1]
              case "*.tar.bz2"  ; tar xjf $argv[1]
              case "*.tar.gz"   ; tar xzf $argv[1]
              case "*.tar.xz"   ; tar xJf $argv[1]
              case "*.bz2"      ; bunzip2  $argv[1]
              case "*.rar"      ; unrar e  $argv[1]
              case "*.gz"       ; gunzip   $argv[1]
              case "*.tar"      ; tar xf   $argv[1]
              case "*.zip"      ; unzip    $argv[1]
              case "*.7z"       ; 7z x     $argv[1]
              case "*"          ; echo "Don't know how to extract '$argv[1]'"
            end
          '';
        };

        backup = {
          description = "copy file to <file>.bak-<timestamp>";
          body = ''
            if test -z "$argv[1]"
              echo "Usage: backup <file>"
              return 1
            end
            cp $argv[1] $argv[1].bak-(date +%Y%m%d-%H%M%S)
          '';
        };

        # mkvenv can't be a plain alias because it needs sequential commands.
        # posix aliases use &&; fish uses 'and'.
        mkvenv = {
          description = "create venv and activate it";
          body = ''
            python3 -m venv venv; and source venv/bin/activate.fish
          '';
        };

        gwt = {
          description = "git worktree helper";
          body = ''
            if test (count $argv) -eq 0
              git worktree list
            else
              git worktree add $argv
            end
          '';
        };
      };

      # --------------------------------------------------------------- #
      # PLUGINS                                                           #
      # home-manager installs these into the fish data dir at build time; #
      # no fisher/runtime plugin manager needed.                          #
      #                                                                   #
      # fzf.fish       — rich fzf widgets (file, dir, process, var,      #
      #                  history). Replaces plain fzf shell integration.  #
      #                  Requires: fzf + fd in PATH (both in packages).   #
      #                                                                   #
      # autopair.fish  — auto-close brackets and quotes.                  #
      #                                                                   #
      # done           — desktop notification when a long command (>10s)  #
      #                  finishes in the background.                       #
      #                                                                   #
      # sponge         — removes failed/interrupted commands from history  #
      #                  automatically.                                    #
      # --------------------------------------------------------------- #
      plugins = [
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
      ];
    };

    # ----------------------------------------------------------------- #
    # DIRENV — hook injected by HM; no manual eval in interactiveShellInit
    # ----------------------------------------------------------------- #
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    # ----------------------------------------------------------------- #
    # FZF                                                                 #
    # enableFishIntegration is OFF — fzf.fish plugin above provides the  #
    # fish-side widgets and is richer. The HM fzf block still sets       #
    # FZF_DEFAULT_COMMAND / FZF_DEFAULT_OPTS via the env vars it exports. #
    # ----------------------------------------------------------------- #
    fzf = {
      enable = true;
      enableFishIntegration = false; # handled by fzf.fish plugin

      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f"
        "--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
      ];

      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      changeDirWidgetOptions = ["--preview 'eza --tree --color=always {} | head -200'"];
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidgetOptions = ["--preview 'bat --color=always --style=numbers --line-range=:500 {}'"];
    };

    # ----------------------------------------------------------------- #
    # ZOXIDE — hook injected by HM; no manual eval needed                 #
    # ----------------------------------------------------------------- #
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };

    # ----------------------------------------------------------------- #
    # BAT                                                                  #
    # ----------------------------------------------------------------- #
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        pager = "less -FR";
        style = "numbers,changes,header";
        italic-text = "always";
      };
    };

    # ----------------------------------------------------------------- #
    # EZA                                                                  #
    # enableFishIntegration is OFF — it would add its own aliases that    #
    # conflict with the shellAbbrs above.                                  #
    # ----------------------------------------------------------------- #
    eza = {
      enable = true;
      enableFishIntegration = false;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };

  home.packages = with pkgs; [
    fd
    zoxide
    unrar
    p7zip
    # fzf, bat, eza, direnv — declared via programs.* above
  ];
}
