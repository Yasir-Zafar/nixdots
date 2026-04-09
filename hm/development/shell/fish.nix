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
      # runs in every interactive shell (equivalent of zshrc)            #
      # --------------------------------------------------------------- #
      interactiveShellInit = ''
        # disable the default greeting
        set fish_greeting

        # --- zoxide (cd replacement) ---
        ${pkgs.zoxide}/bin/zoxide init --cmd cd fish | source

        # --- direnv ---
        ${pkgs.direnv}/bin/direnv hook fish | source

        # --- fzf key bindings ---
        # fzf.fish plugin below handles this; listed here for visibility

        # --- history options (fish handles dedup natively) ---
        set -g fish_history_merge true
      '';

      # --------------------------------------------------------------- #
      # ABBREVIATIONS (expand on space/enter; like zsh aliases)          #
      # --------------------------------------------------------------- #
      shellAbbrs = {
        # navigation
        ".."   = "cd ..";
        "..."  = "cd ../..";
        "...." = "cd ../../..";

        # git
        g   = "git";
        ga  = "git add";
        gc  = "git commit";
        gco = "git checkout";
        gd  = "git diff";
        gf  = "git fetch";
        gl  = "git log --oneline --graph --decorate";
        gp  = "git push";
        gs  = "git status";
        gst = "git stash";

        # eza
        ls  = "eza";
        la  = "eza -a";
        ll  = "eza -lh";
        lla = "eza -lha";
        lt  = "eza --tree";

        # misc
        v   = "nvim";
        vim = "nvim";
        cat = "bat";
      };

      # --------------------------------------------------------------- #
      # FUNCTIONS                                                         #
      # --------------------------------------------------------------- #
      functions = {
        # mkdir + cd in one shot
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

        # extract common archive formats
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

        # timestamped backup
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

        # git worktree shorthand (gwt with no args = list; with args = add)
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
      # PLUGINS (via fisher-compatible pkgs or home-manager fish.plugins) #
      # --------------------------------------------------------------- #
      plugins = [
        # fzf.fish: Ctrl+R history, Ctrl+T files, Alt+C dirs — same as your zsh setup
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        # autopair: auto-close brackets/quotes
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        # done: desktop notification when long commands finish
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        # sponge: remove failed commands from history automatically
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
      ];
    };

    # ----------------------------------------------------------------- #
    # STARSHIP — reuse your existing config untouched                    #
    # ----------------------------------------------------------------- #
    starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$nix_shell$python$nodejs$rust$java$character";

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold yellow)";
        };

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold blue";
          home_symbol = "~";
        };

        git_branch = {
          format = "[$symbol$branch]($style) ";
          style = "bold green";
          symbol = " ";
        };

        git_status = {
          format = "([\\[$all_status$ahead_behind\\]]($style) )";
          style = "bold yellow";
          conflicted = "⚡";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          up_to_date = "";
          untracked = "?\${count}";
          modified = "!\${count}";
          staged = "+\${count}";
          deleted = "✘\${count}";
        };

        nix_shell = {
          disabled = false;
          format = "[$symbol$state]($style) ";
          symbol = "❄️ ";
          style = "bold cyan";
          impure_msg = "impure";
          pure_msg = "pure";
        };

        python = {
          format = "[\${symbol}(\${version})(\\ \\(\$virtualenv\\))]($style) ";
          style = "bold yellow";
          symbol = " ";
        };

        nodejs = {
          format = "[$symbol(\$version)]($style) ";
          style = "bold green";
          symbol = " ";
        };

        rust = {
          format = "[$symbol(\$version)]($style) ";
          style = "bold red";
          symbol = " ";
        };

        java = {
          format = "[$symbol(\$version)]($style) ";
          style = "bold orange";
          symbol = " ";
        };

        username.disabled = true;
        hostname.disabled = true;
        docker_context.disabled = true;
        kubernetes.disabled = true;
        ruby.disabled = true;
        c.disabled = true;
        cmake.disabled = true;
        package.disabled = true;
        golang.disabled = true;
      };
    };

    # ----------------------------------------------------------------- #
    # DIRENV — same as before                                            #
    # ----------------------------------------------------------------- #
    direnv = {
      enable = true;
      enableFishIntegration = true; # also set enableBashIntegration if you keep bash
      nix-direnv.enable = true;
    };

    # ----------------------------------------------------------------- #
    # FZF                                                                #
    # ----------------------------------------------------------------- #
    fzf = {
      enable = true;
      enableFishIntegration = true;

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
    # BAT — unchanged                                                    #
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
    # EZA — unchanged                                                    #
    # ----------------------------------------------------------------- #
    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };

  # extra packages used by the shell setup above
  home.packages = with pkgs; [
    fd
    fzf
    zoxide
    bat
    eza
    direnv
    unrar
    p7zip
    # fishPlugins packages are referenced above via plugins list;
    # no need to add them here separately
  ];
}
