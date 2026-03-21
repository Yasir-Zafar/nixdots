{
  config,
  pkgs,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      zplug = {
        enable = true;
        plugins = [
          {name = "zsh-users/zsh-completions";}
          {name = "zdharma-continuum/fast-syntax-highlighting";}
          {name = "zsh-users/zsh-autosuggestions";}
          {name = "Aloxaf/fzf-tab";}
          {name = "zsh-users/zsh-history-substring-search";}
        ];
      };

      history = {
        size = 10000;
        save = 10000;
        path = "${config.home.homeDirectory}/.zsh_history";
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
        extended = true;
      };

      defaultKeymap = "emacs";

      sessionVariables = {
        FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
        FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
        FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";
        FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --inline-info";
        _ZO_ECHO = "1";
        _ZO_RESOLVE_SYMLINKS = "1";
      };

      initContent = ''
        # --- keybindings ---
        bindkey -e
        bindkey '^p'   history-substring-search-up
        bindkey '^n'   history-substring-search-down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^r'   fzf-history-widget
        bindkey '^[c'  fzf-cd-widget
        bindkey '^t'   fzf-file-widget

        # --- options ---
        setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
        setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD LIST_PACKED
        setopt HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY
        setopt CORRECT EXTENDED_GLOB GLOB_DOTS

        # --- completion styling ---
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' rehash true
        zstyle ':completion:*' menu no
        zstyle ':completion:*' use-cache true
        zstyle ':completion:*' cache-path "$HOME/.zcompcache"
        zstyle ':completion:*:descriptions' format '%B%d%b'
        zstyle ':completion:*' group-name '''

        # --- fzf-tab previews ---
        zstyle ':fzf-tab:complete:cd:*'              fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*'      fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'

        # --- autosuggestions ---
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

        # --- tool integrations ---
        eval "$(${pkgs.fzf}/bin/fzf --zsh)"
        eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

        # --- functions ---
        function mkcd() {
          [[ -z "$1" ]] && { echo "Usage: mkcd <dir>"; return 1; }
          mkdir -p "$1" && cd "$1"
        }

        function extract() {
          [[ -z "$1" ]]    && { echo "Usage: extract <archive>"; return 1; }
          [[ ! -f "$1" ]]  && { echo "Not a file: $1"; return 1; }
          case $1 in
            *.tar.bz2) tar xjf "$1" ;; *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;; *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar e "$1" ;; *.gz)       gunzip  "$1" ;;
            *.tar)     tar xf  "$1" ;; *.zip)      unzip   "$1" ;;
            *.7z)      7z x    "$1" ;;
            *) echo "Don't know how to extract '$1'" ;;
          esac
        }

        function backup() {
          [[ -z "$1" ]] && { echo "Usage: backup <file>"; return 1; }
          cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
        }

        function gwt() {
          [[ $# -eq 0 ]] && git worktree list || git worktree add "$@"
        }

        [[ -f ~/.zsh_private ]] && source ~/.zsh_private
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

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

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        pager = "less -FR";
        style = "numbers,changes,header";
        italic-text = "always";
      };
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
