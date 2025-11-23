# hm/development/tools/terminal.nix
{
  config,
  pkgs,
  ...
}: {
  # Terminal applications and tools
  home.packages = with pkgs; [
    # Terminal file manager
    yazi

    # System monitoring
    htop
    iotop

    # Archive tools
    unzip
    p7zip
    unrar

    # Network tools
    curl
    wget
    httpie

    # Text processing
    jq
    yq

    # System tools
    htop
    btop # Modern htop alternative
    tree
    neofetch
    fastfetch
    dust # Better du
    procs # Better ps

    # Development utilities
    just # Command runner
    direnv # Environment management
    nix-direnv

    # Core shell utilities
    eza # Modern ls replacement
    bat # Modern cat with syntax highlighting
    fd # Modern find replacement
    ripgrep # Modern grep replacement
    fzf # Fuzzy finder
    zoxide # Smart cd command

    # System monitoring
    btop # Modern top replacement
    procs # Modern ps replacement
    dust # Modern du replacement
    duf # Modern df replacement

    lazygit # Git TUI
    gh # GitHub CLI

    # Archive tools
    unzip
    p7zip

    # Network tools
    wget
    curl

    # Terminal multiplexer
    zellij

    # Nix helpers
    nh # Nix helper
    nix-tree # Visualize nix dependencies

    # System utilities
    lesspipe # Better less preprocessing
  ];

  programs = {
    # Enable Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true; # You disabled this but use zsh-completions plugin - inconsistent!
      autosuggestion.enable = false; # Handled by zplug plugin instead
      syntaxHighlighting.enable = false; # Will use fast-syntax-highlighting instead

      # zplug configuration with better plugins
      zplug = {
        enable = true;
        plugins = [
          # Enhanced completions
          {
            name = "zsh-users/zsh-completions";
            tags = ["defer:0"];
          }
          # Better autosuggestions
          {
            name = "zsh-users/zsh-autosuggestions";
            tags = ["defer:2"];
          }
          # Faster syntax highlighting
          {
            name = "zdharma-continuum/fast-syntax-highlighting";
            tags = ["defer:2"];
          }
          # Better history search
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = ["defer:2"];
          }
          # Enhanced tab completion with fzf
          {
            name = "Aloxaf/fzf-tab";
            tags = ["defer:2"];
          }
          # Git extras
          {
            name = "wfxr/forgit";
            tags = ["defer:2"];
          }
          # Directory jumping
          {
            name = "agkozak/zsh-z";
            tags = ["defer:1"];
          }
          # Auto-pair brackets
          {
            name = "hlissner/zsh-autopair";
            tags = ["defer:2"];
          }
        ];
      };

      # Shell history configuration
      history = {
        size = 10000; # Increased from 5000
        path = "${config.home.homeDirectory}/.zsh_history";
        save = 10000;
        ignoreDups = true;
        ignoreSpace = true; # Ignore commands that start with space
        extended = true; # Save timestamps
        share = true; # Share history between sessions
      };

      # Environment variables
      sessionVariables = {
        # FZF configuration
        FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
        FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
        FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";

        # Less configuration for better bat integration
        LESS = "-R";
        LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";

        # Zoxide configuration
        _ZO_ECHO = "1";
      };

      # Enhanced shell configuration
      initContent = ''
        # Keybindings
        bindkey -e  # Emacs-style keybindings

        # History search keybindings
        bindkey '^p' history-substring-search-up
        bindkey '^n' history-substring-search-down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        # Enhanced completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' rehash true
        zstyle ':completion:*' menu no
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' complete-options true
        zstyle ':completion:*' use-cache true
        zstyle ':completion:*' cache-path "$HOME/.zcompcache"

        # fzf-tab configuration
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

        # Auto-suggestions configuration
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

        # Shell integrations
        eval "$(${pkgs.fzf}/bin/fzf --zsh)"
        eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"

        # Custom functions
        function mkcd() {
          mkdir -p "$1" && cd "$1"
        }

        function extract() {
          if [ -f $1 ] ; then
            case $1 in
              *.tar.bz2)   tar xjf $1     ;;
              *.tar.gz)    tar xzf $1     ;;
              *.bz2)       bunzip2 $1     ;;
              *.rar)       unrar e $1     ;;
              *.gz)        gunzip $1      ;;
              *.tar)       tar xf $1      ;;
              *.tbz2)      tar xjf $1     ;;
              *.tgz)       tar xzf $1     ;;
              *.zip)       unzip $1       ;;
              *.Z)         uncompress $1  ;;
              *.7z)        7z x $1        ;;
              *)     echo "'$1' cannot be extracted via extract()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }

        # Git worktree helper
        function gwt() {
          if [ $# -eq 0 ]; then
            git worktree list
          else
            git worktree add "$@"
          fi
        }
      '';

      # Clean and organized aliases
      shellAliases = {
        # Navigation aliases
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # Enhanced ls alternatives
        "l" = "eza --icons --group-directories-first";
        "ll" = "eza --long --all --icons --group-directories-first --git";
        "la" = "eza --all --icons --group-directories-first";
        "lt" = "eza --tree --level=2 --icons";
        "llt" = "eza --tree --long --icons";

        # File operations
        "cp" = "cp -i"; # Prompt before overwrite
        "mv" = "mv -i"; # Prompt before overwrite
        "rm" = "rm -i"; # Prompt before delete
        "mkdir" = "mkdir -pv"; # Create parent dirs and be verbose

        # Modern alternatives
        "cat" = "bat --style=plain --paging=never";
        "bat" = "bat --style=numbers,changes --theme='gruvbox-dark'";
        "grep" = "rg";
        "find" = "fd";
        "ps" = "procs";
        "du" = "dust";
        "df" = "duf";
        "top" = "btop";

        # Git shortcuts
        "g" = "git";
        "ga" = "git add";
        "gaa" = "git add --all";
        "gc" = "git commit -v";
        "gca" = "git commit -v -a";
        "gco" = "git checkout";
        "gd" = "git diff";
        "gl" = "git log --oneline --graph --decorate";
        "gp" = "git push";
        "gpu" = "git pull";
        "gs" = "git status -sb";

        # Quick commands
        "n" = "nvim";
        "v" = "nvim";
        "c" = "clear";
        "h" = "history";
        "j" = "jobs -l";

        # System shortcuts
        "reload" = "exec zsh";
        "path" = "echo -e \${PATH//:/\\n}";
        "ports" = "netstat -tulanp";

        # Enhanced file search and navigation
        "ff" = "fd --type f | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
        "fdir" = "fd --type d | fzf --preview 'eza --tree --level=1 --color=always {}'";
        "fzv" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(nvim {})'";

        # NixOS shortcuts (cleaned up)
        "hu" = "nh home switch ~/nix-config/hm/"; # Updated path
        "nu" = "nh os switch ~/nix-config/nixos/"; # Updated path
        "nfu" = "nix flake update";
        "ncg" = "nix-collect-garbage -d";
        "nso" = "nix store optimise";

        # Development shortcuts
        "serve" = "python3 -m http.server 8000";
        "myip" = "curl -s https://ipinfo.io/ip";
        "weather" = "curl -s 'https://wttr.in?format=3'";
      };
    };

    # Starship prompt configuration (enhanced)
    starship = {
      enable = true;
      enableZshIntegration = true;
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
        };

        git_branch = {
          format = "[$branch]($style) ";
          style = "bold green";
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
        };

        python = {
          format = "[\${symbol}\${pyenv_prefix}(\${version})(\\(\$virtualenv\\))]($style) ";
          style = "bold yellow";
        };

        # Disable less useful modules
        kubernetes = {disabled = true;};
        ruby = {disabled = true;};
        c = {disabled = true;};
      };
    };

    # Required packages (organized and enhanced)

    # Direnv integration
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # Bash configuration
    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        ll = "eza -l --icons";
        la = "eza -la --icons";
        lt = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";
        ps = "procs";
        du = "dust";

        # System aliases
        rebuild-nixos = "sudo nixos-rebuild switch --flake ~/nix-config/nixos";
        rebuild-home = "home-manager switch --flake ~/nix-config/hm";

        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      initExtra = ''
        # Custom prompt
        export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

        # FZF configuration
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # History settings
        export HISTSIZE=10000
        export HISTFILESIZE=10000
        export HISTCONTROL=ignoreboth
        shopt -s histappend
      '';
    };

    # FZF integration
    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };

    # Bat configuration
    bat = {
      enable = true;
      config = {
        theme = "Gruvbox";
        pager = "less -FR";
      };
    };

    # Eza configuration
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };
  };
}
