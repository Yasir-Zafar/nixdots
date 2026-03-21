{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide

    tree
    dust
    duf
    ncdu

    unzip
    p7zip
    unrar

    curl
    wget

    nh
    nix-tree
    nix-output-monitor
    nvd
  ];

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
        LESS = "-R --use-color -Dd+r$Du+b";
        BAT_THEME = "gruvbox-dark";
        _ZO_ECHO = "1";
        _ZO_RESOLVE_SYMLINKS = "1";
      };

      initContent = ''
        bindkey -e
        bindkey '^p' history-substring-search-up
        bindkey '^n' history-substring-search-down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^r' fzf-history-widget
        bindkey '^[c' fzf-cd-widget
        bindkey '^t' fzf-file-widget

        setopt AUTO_CD
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT
        setopt ALWAYS_TO_END
        setopt AUTO_MENU
        setopt COMPLETE_IN_WORD
        setopt LIST_PACKED
        setopt HIST_VERIFY
        setopt INC_APPEND_HISTORY
        setopt SHARE_HISTORY
        setopt CORRECT
        setopt EXTENDED_GLOB
        setopt GLOB_DOTS

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' rehash true
        zstyle ':completion:*' menu select
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' verbose true
        zstyle ':completion:*:descriptions' format '%B%d%b'
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*' use-cache true
        zstyle ':completion:*' cache-path "$HOME/.zcompcache"

        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

        eval "$(${pkgs.fzf}/bin/fzf --zsh)"
        eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

        function mkcd() {
          if [[ -z "$1" ]]; then echo "Usage: mkcd <directory>"; return 1; fi
          mkdir -p "$1" && cd "$1"
        }

        function extract() {
          if [[ -z "$1" ]]; then echo "Usage: extract <archive>"; return 1; fi
          if [[ ! -f "$1" ]]; then echo "Error: '$1' is not a valid file"; return 1; fi
          case $1 in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.tar.xz)    tar xJf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar e "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *)           echo "Error: '$1' cannot be extracted via extract()" ;;
          esac
        }

        function backup() {
          if [[ -z "$1" ]]; then echo "Usage: backup <file>"; return 1; fi
          cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        }

        function gwt() {
          if [[ $# -eq 0 ]]; then git worktree list; else git worktree add "$@"; fi
        }

        function replace() {
          if [[ $# -lt 2 ]]; then echo "Usage: replace <search> <replace> [path]"; return 1; fi
          local path="''${3:-.}"
          fd -t f -x sed -i "s/$1/$2/g" {} \; "$path"
        }

        function serve() {
          local port="''${1:-8000}"
          python3 -m http.server "$port"
        }

        [[ -f ~/.zsh_private ]] && source ~/.zsh_private
      '';

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "-" = "cd -";

        "l" = "eza --icons --group-directories-first";
        "ll" = "eza --long --all --icons --group-directories-first --git";
        "la" = "eza --all --icons --group-directories-first";
        "lt" = "eza --tree --level=2 --icons";
        "llt" = "eza --tree --long --icons";
        "l1" = "eza -1 --icons";

        "cp" = "cp -i";
        "mv" = "mv -i";
        "rm" = "rm -i";
        "mkdir" = "mkdir -pv";

        "cat" = "bat --style=plain --paging=never";
        "less" = "bat --style=full --paging=always";
        "grep" = "rg";
        "find" = "fd";
        "ps" = "procs";
        "du" = "dust";
        "df" = "duf";
        "top" = "btop";

        "g" = "git";
        "ga" = "git add";
        "gaa" = "git add --all";
        "gc" = "git commit -v";
        "gca" = "git commit -v -a";
        "gcm" = "git commit -m";
        "gco" = "git checkout";
        "gd" = "git diff";
        "gl" = "git log --oneline --graph --decorate";
        "gp" = "git push";
        "gpu" = "git pull";
        "gs" = "git status -sb";
        "lg" = "lazygit";

        "n" = "nvim";
        "v" = "nvim";
        "c" = "clear";
        "h" = "history";
        "j" = "jobs -l";
        "e" = "exit";

        "reload" = "exec zsh";
        "path" = "echo -e \${PATH//:/\\n}";
        "ports" = "netstat -tulanp";

        "ff" = "fd --type f | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
        "fdir" = "fd --type d | fzf --preview 'eza --tree --level=1 --color=always {}'";
        "fv" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(nvim {})'";

        "hs" = "nh home switch ~/nix-config/hm";
        "hb" = "nh home build ~/nix-config/hm";
        "ns" = "nh os switch ~/nix-config/nixos";
        "nb" = "nh os build ~/nix-config/nixos";
        "nt" = "nh os test ~/nix-config/nixos";
        "nfu" = "nix flake update --flake ~/nix-config/nixos && nix flake update --flake ~/nix-config/hm";
        "ncg" = "nh clean all";
        "nso" = "nix store optimise";

        "myip" = "curl -s https://ipinfo.io/ip";
        "localip" = "ip addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1";
        "weather" = "curl -s 'https://wttr.in?format=3'";

        "d" = "docker";
        "dc" = "docker-compose";
        "dps" = "docker ps";
        "di" = "docker images";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      settings = {
        add_newline = false;
        format = "$username$hostname$directory$git_branch$git_status$nix_shell$python$nodejs$rust$go$java$docker_context$character";

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold yellow)";
        };

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold blue";
          format = "[$path]($style)[$read_only]($read_only_style) ";
          read_only = " 🔒";
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
          stashed = "$\${count}";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
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
          format = "[\${symbol}\${pyenv_prefix}(\${version})(\\(\$virtualenv\\))]($style) ";
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

        docker_context = {
          format = "[$symbol$context]($style) ";
          style = "bold blue";
          symbol = " ";
        };

        kubernetes.disabled = true;
        ruby.disabled = true;
        c.disabled = true;
        cmake.disabled = true;
        package.disabled = true;
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
