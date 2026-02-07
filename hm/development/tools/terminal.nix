# ============================================================================
# Terminal Tools and Shell Configuration
# Location: hm/development/tools/terminal.nix
# ============================================================================
{
  config,
  pkgs,
  ...
}: {
  # ==========================================================================
  # TERMINAL PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # Modern Core Tools
    # ------------------------------------------------------------------------
    eza # Modern ls replacement with icons and colors
    bat # Cat with syntax highlighting
    fd # Fast find alternative
    ripgrep # Fast grep alternative (rg)
    fzf # Fuzzy finder
    zoxide # Smarter cd command

    # ------------------------------------------------------------------------
    # File & Directory Utilities
    # ------------------------------------------------------------------------
    tree # Directory tree viewer
    dust # Modern du alternative
    duf # Modern df alternative
    ncdu # NCurses disk usage analyzer

    # ------------------------------------------------------------------------
    # Archive Tools
    # ------------------------------------------------------------------------
    unzip # ZIP extraction
    p7zip # 7z archive support
    unrar # RAR extraction

    # ------------------------------------------------------------------------
    # Network Tools
    # ------------------------------------------------------------------------
    curl # HTTP client
    wget # File downloader
    httpie # User-friendly HTTP client
    # ngrok # Expose local servers (commented - requires account)

    # ------------------------------------------------------------------------
    # Process & System Monitoring
    # ------------------------------------------------------------------------
    procs # Modern ps alternative
    htop # Interactive process viewer
    btop # Beautiful system monitor

    # ------------------------------------------------------------------------
    # Development Tools
    # ------------------------------------------------------------------------
    just # Command runner (Makefile alternative)
    lazygit # Terminal UI for git
    gh # GitHub CLI

    # ------------------------------------------------------------------------
    # Nix Tools
    # ------------------------------------------------------------------------
    nh # Nix helper tool
    nix-tree # Visualize Nix dependencies
    nix-output-monitor # Better nix build output (nom)
    nvd # Nix version diff tool

    # ------------------------------------------------------------------------
    # Additional Utilities
    # ------------------------------------------------------------------------
    # tldr # Simplified man pages
    # tokei # Code statistics
    # hyperfine # Command-line benchmarking
    # jq # JSON processor
    # yq # YAML processor
  ];

  # ==========================================================================
  # PROGRAMS CONFIGURATION
  # ==========================================================================
  programs = {
    # ========================================================================
    # ZSH CONFIGURATION
    # ========================================================================
    zsh = {
      enable = true;
      enableCompletion = true; # Native Zsh completion system
      autosuggestion.enable = true; # Built-in autosuggestions

      # ----------------------------------------------------------------------
      # Zsh Plugin Manager
      # ----------------------------------------------------------------------
      zplug = {
        enable = true;
        plugins = [
          # Completion enhancements
          {name = "zsh-users/zsh-completions";}

          # Fast syntax highlighting (faster than zsh-syntax-highlighting)
          {name = "zdharma-continuum/fast-syntax-highlighting";}

          # Intelligent autosuggestions
          {name = "zsh-users/zsh-autosuggestions";}

          # FZF integration with better completion
          {name = "Aloxaf/fzf-tab";}

          # Better history search with substring matching
          {name = "zsh-users/zsh-history-substring-search";}
        ];
      };

      # ----------------------------------------------------------------------
      # History Configuration
      # ----------------------------------------------------------------------
      history = {
        size = 10000; # Number of commands in memory
        save = 10000; # Number of commands saved to file
        path = "${config.home.homeDirectory}/.zsh_history";
        share = true; # Share history between sessions
        ignoreDups = true; # Don't save duplicate commands
        ignoreSpace = true; # Don't save commands starting with space
        expireDuplicatesFirst = true; # Remove duplicates first when trimming
        extended = true; # Save timestamp of command
      };

      # ----------------------------------------------------------------------
      # Zsh Options
      # ----------------------------------------------------------------------
      defaultKeymap = "emacs"; # Use emacs-style keybindings

      # ----------------------------------------------------------------------
      # Environment Variables (Zsh-specific)
      # ----------------------------------------------------------------------
      sessionVariables = {
        # FZF configuration
        FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
        FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
        FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";
        FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --inline-info";

        # Less configuration for better bat integration
        LESS = "-R --use-color -Dd+r$Du+b";

        # Bat theme
        BAT_THEME = "gruvbox-dark";

        # Zoxide configuration
        _ZO_ECHO = "1"; # Print matched directory
        _ZO_RESOLVE_SYMLINKS = "1"; # Resolve symlinks
      };

      # ----------------------------------------------------------------------
      # Zsh Initialization
      # ----------------------------------------------------------------------
      initContent = ''
        # ====================================================================
        # KEYBINDINGS
        # ====================================================================
        # Emacs-style keybindings (default)
        bindkey -e

        # History search with arrows
        bindkey '^p' history-substring-search-up
        bindkey '^n' history-substring-search-down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        # Ctrl+R for FZF history search
        bindkey '^r' fzf-history-widget

        # Alt+C for FZF directory change
        bindkey '^[c' fzf-cd-widget

        # Ctrl+T for FZF file selection
        bindkey '^t' fzf-file-widget

        # ====================================================================
        # ZSH OPTIONS
        # ====================================================================
        # Directory navigation
        setopt AUTO_CD              # cd by typing directory name
        setopt AUTO_PUSHD           # Make cd push old dir to stack
        setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
        setopt PUSHD_SILENT         # Don't print directory stack

        # Completion
        setopt ALWAYS_TO_END        # Move cursor to end after completion
        setopt AUTO_MENU            # Show completion menu on tab
        setopt COMPLETE_IN_WORD     # Complete from both ends
        setopt LIST_PACKED          # Compact completion lists

        # History
        setopt HIST_VERIFY          # Show command before executing from history
        setopt INC_APPEND_HISTORY   # Add commands immediately
        setopt SHARE_HISTORY        # Share history between sessions

        # Correction
        setopt CORRECT              # Spelling correction for commands
        # setopt CORRECT_ALL        # Spelling correction for arguments (can be annoying)

        # Globbing
        setopt EXTENDED_GLOB        # Extended globbing
        setopt GLOB_DOTS            # Include nix-config in glob

        # ====================================================================
        # COMPLETION STYLING
        # ====================================================================
        # Case-insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

        # Use LS_COLORS for file completion
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        # Always rehash commands (find new commands in PATH)
        zstyle ':completion:*' rehash true

        # Use menu selection
        zstyle ':completion:*' menu select

        # Squeeze multiple slashes
        zstyle ':completion:*' squeeze-slashes true

        # Show descriptions
        zstyle ':completion:*' verbose true
        zstyle ':completion:*:descriptions' format '%B%d%b'

        # Group matches
        zstyle ':completion:*' group-name '''

        # Use cache
        zstyle ':completion:*' use-cache true
        zstyle ':completion:*' cache-path "$HOME/.zcompcache"

        # ====================================================================
        # FZF-TAB CONFIGURATION
        # ====================================================================
        # Disable default FZF tab completion
        zstyle ':completion:*' menu no

        # Preview directory contents with eza
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'

        # Preview processes in kill command
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
        zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'

        # Use tmux popup for fzf-tab (if in tmux)
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

        # ====================================================================
        # AUTOSUGGESTIONS CONFIGURATION
        # ====================================================================
        # Strategy: history then completion
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)

        # Don't suggest for very long buffers
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

        # Highlight style
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

        # ====================================================================
        # SHELL INTEGRATIONS
        # ====================================================================
        # FZF integration
        eval "$(${pkgs.fzf}/bin/fzf --zsh)"

        # Zoxide integration (replaces cd with smart directory jumping)
        eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"

        # Direnv integration (auto-load environment variables)
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

        # ====================================================================
        # CUSTOM FUNCTIONS
        # ====================================================================
        # Create directory and cd into it
        function mkcd() {
          if [[ -z "$1" ]]; then
            echo "Usage: mkcd <directory>"
            return 1
          fi
          mkdir -p "$1" && cd "$1"
        }

        # Extract various archive formats
        function extract() {
          if [[ -z "$1" ]]; then
            echo "Usage: extract <archive>"
            return 1
          fi

          if [[ ! -f "$1" ]]; then
            echo "Error: '$1' is not a valid file"
            return 1
          fi

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

        # Backup file with timestamp
        function backup() {
          if [[ -z "$1" ]]; then
            echo "Usage: backup <file>"
            return 1
          fi
          cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        }

        # Git worktree helper
        function gwt() {
          if [[ $# -eq 0 ]]; then
            git worktree list
          else
            git worktree add "$@"
          fi
        }

        # Find and replace in files
        function replace() {
          if [[ $# -lt 2 ]]; then
            echo "Usage: replace <search> <replace> [path]"
            return 1
          fi
          local path="''${3:-.}"
          fd -t f -x sed -i "s/$1/$2/g" {} \; "$path"
        }

        # Quick server
        function serve() {
          local port="''${1:-8000}"
          python3 -m http.server "$port"
        }

        # ====================================================================
        # ADDITIONAL CUSTOMIZATIONS
        # ====================================================================
        # Load private aliases/functions if they exist
        [[ -f ~/.zsh_private ]] && source ~/.zsh_private
      '';

      # ----------------------------------------------------------------------
      # Zsh Aliases
      # ----------------------------------------------------------------------
      shellAliases = {
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "-" = "cd -"; # Go to previous directory

        # Enhanced ls with eza
        "l" = "eza --icons --group-directories-first";
        "ll" = "eza --long --all --icons --group-directories-first --git";
        "la" = "eza --all --icons --group-directories-first";
        "lt" = "eza --tree --level=2 --icons";
        "llt" = "eza --tree --long --icons";
        "l1" = "eza -1 --icons"; # One file per line

        # File operations with safety
        "cp" = "cp -i"; # Prompt before overwrite
        "mv" = "mv -i"; # Prompt before overwrite
        "rm" = "rm -i"; # Prompt before delete
        "mkdir" = "mkdir -pv"; # Create parent dirs and be verbose

        # Modern tool alternatives
        "cat" = "bat --style=plain --paging=never";
        "less" = "bat --style=full --paging=always";
        "grep" = "rg";
        "find" = "fd";
        "ps" = "procs";
        "du" = "dust";
        "df" = "duf";
        "top" = "btop";

        # Git shortcuts (essential ones, detailed ones in git.nix)
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
        "lg" = "lazygit"; # Launch lazygit

        # Quick commands
        "n" = "nvim";
        "v" = "nvim";
        "c" = "clear";
        "h" = "history";
        "j" = "jobs -l";
        "e" = "exit";

        # System shortcuts
        "reload" = "exec zsh";
        "path" = "echo -e \${PATH//:/\\n}";
        "ports" = "netstat -tulanp";

        # FZF-enhanced commands
        "ff" = "fd --type f | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
        "fdir" = "fd --type d | fzf --preview 'eza --tree --level=1 --color=always {}'";
        "fv" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(nvim {})'";

        # NixOS shortcuts
        "hs" = "nh home switch ~/nix-config/hm";
        "hb" = "nh home build ~/nix-config/hm";
        "ns" = "nh os switch ~/nix-config/nixos";
        "nb" = "nh os build ~/nix-config/nixos";
        "nt" = "nh os test ~/nix-config/nixos"; # New: test config
        "nfu" = "nix flake update --flake ~/nix-config/nixos && nix flake update --flake ~/nix-config/hm"; # Keep this one
        "ncg" = "nh clean all"; # Better: keep 5 generations
        "nso" = "nix store optimise"; # Keep this one

        # Development shortcuts
        "serve" = "python3 -m http.server 8000";
        "myip" = "curl -s https://ipinfo.io/ip";
        "localip" = "ip addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | cut -d/ -f1";
        "weather" = "curl -s 'https://wttr.in?format=3'";

        # Docker shortcuts (if using Docker)
        "d" = "docker";
        "dc" = "docker-compose";
        "dps" = "docker ps";
        "di" = "docker images";
      };
    };

    # ========================================================================
    # STARSHIP PROMPT
    # ========================================================================
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      settings = {
        # Add newline between prompts
        add_newline = false;

        # Prompt format
        format = "$username$hostname$directory$git_branch$git_status$nix_shell$python$nodejs$rust$go$java$docker_context$character";

        # ----------------------------------------------------------------------
        # Character (Prompt Symbol)
        # ----------------------------------------------------------------------
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold yellow)";
        };

        # ----------------------------------------------------------------------
        # Directory
        # ----------------------------------------------------------------------
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold blue";
          format = "[$path]($style)[$read_only]($read_only_style) ";
          read_only = " 🔒";
          home_symbol = "~";
        };

        # ----------------------------------------------------------------------
        # Git Branch
        # ----------------------------------------------------------------------
        git_branch = {
          format = "[$symbol$branch]($style) ";
          style = "bold green";
          symbol = " ";
        };

        # ----------------------------------------------------------------------
        # Git Status
        # ----------------------------------------------------------------------
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

        # ----------------------------------------------------------------------
        # Nix Shell
        # ----------------------------------------------------------------------
        nix_shell = {
          disabled = false;
          format = "[$symbol$state]($style) ";
          symbol = "❄️ ";
          style = "bold cyan";
          impure_msg = "impure";
          pure_msg = "pure";
        };

        # ----------------------------------------------------------------------
        # Programming Languages
        # ----------------------------------------------------------------------
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

        # ----------------------------------------------------------------------
        # Docker
        # ----------------------------------------------------------------------
        docker_context = {
          format = "[$symbol$context]($style) ";
          style = "bold blue";
          symbol = " ";
        };

        # ----------------------------------------------------------------------
        # Disable Less Useful Modules
        # ----------------------------------------------------------------------
        kubernetes = {disabled = true;};
        ruby = {disabled = true;};
        c = {disabled = true;};
        cmake = {disabled = true;};
        package = {disabled = true;};
      };
    };

    # ========================================================================
    # DIRENV INTEGRATION
    # ========================================================================
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true; # Better Nix integration
    };

    # ========================================================================
    # FZF CONFIGURATION
    # ========================================================================
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

    # ========================================================================
    # BAT CONFIGURATION
    # ========================================================================
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        pager = "less -FR";
        style = "numbers,changes,header";
        italic-text = "always";
      };
    };

    # ========================================================================
    # EZA CONFIGURATION
    # ========================================================================
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

    # ========================================================================
    # BASH CONFIGURATION (Fallback)
    # ========================================================================
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
        ".." = "cd ..";
        "..." = "cd ../..";
      };

      initExtra = ''
        # Basic PS1 prompt
        export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

        # History settings
        export HISTSIZE=10000
        export HISTFILESIZE=10000
        export HISTCONTROL=ignoreboth
        shopt -s histappend

        # FZF integration
        eval "$(${pkgs.fzf}/bin/fzf --bash)"

        # Direnv integration
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      '';
    };
  };
}
# ============================================================================
# TERMINAL CONFIGURATION NOTES
# ============================================================================
# 1. Zsh is the primary shell with extensive plugin support
# 2. Bash is configured as a fallback shell
# 3. Modern tools replace traditional Unix commands
# 4. FZF provides fuzzy finding for files, history, and directories
# 5. Zoxide learns your most-used directories for fast navigation
# 6. Direnv automatically loads project environments
#
# Keybindings:
# - Ctrl+R: FZF history search
# - Ctrl+T: FZF file search
# - Alt+C: FZF directory change
# - Arrows: History substring search
#
# Custom functions:
# - mkcd: Create directory and cd
# - extract: Extract any archive
# - backup: Backup file with timestamp
# - gwt: Git worktree helper
# - serve: Quick HTTP server
# ============================================================================

