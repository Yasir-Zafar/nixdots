{
  pkgs,
  ...
}: {
  # Enable zsh as your default shell
  programs.zsh = {
    enable = true;
    # Using zinit for plugin management instead
    enableCompletion = true;
    history = {
      size = 5000;
      path = "$HOME/.zsh_history";
      save = 5000;
      ignoreDups = true;
      share = true;
      ignoreSpace = true;
    };
    
    initContent = ''
      # Set the directory for zinit
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      
      # Download zinit if not already installed
      if [ ! -d $ZINIT_HOME ]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
      
      # Source zinit
      source "''${ZINIT_HOME}/zinit.zsh"
      
      # Load zinit plugins
      zinit wait lucid light-mode for \
        zsh-users/zsh-syntax-highlighting \
        zsh-users/zsh-completions \
        zsh-users/zsh-autosuggestions \
        zsh-users/zsh-history-substring-search \
        Aloxaf/fzf-tab
      
      # Load zinit snippets
      zinit snippet OMZP::git
      zinit snippet OMZP::sudo
      zinit snippet OMZP::archlinux
      
      # Load completions
      autoload -Uz compinit
        if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
          compinit
        else
          compinit -C
      fi
      zinit cdreplay -q
      
      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      
      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      
      # Shell integrations
      zsh_load_plugins() {
          eval "$(fzf --zsh)"
          eval "$(zoxide init --cmd cd zsh)"
      }
      zsh_load_plugins &!
    '';
    
    shellAliases = {
      l = "lsd --color=auto --group-dirs=first --blocks=name,git";
      ll = "lsd --long --color=auto --group-dirs=first --blocks=date,name,git";
      la = "lsd --long --all --color=auto --group-dirs=first --blocks=date,name,git";
      n = "nvim";
      c = "clear";
      ".." = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      cat = "bat --style=plain --paging=never";
      bat = "bat --style=grid --theme \"gruvbox-dark\"";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log";
      gco = "git checkout";
      gb = "git branch";
      ff = "fd … | fzf —preview \" [[ -f {} ]] && bat -f {} || eza -lah --color=always --tree {}\"";
      hm = "home-manager switch --flake ~/Dotfiles/home#boi --option substituters true";
      nu = "sudo nixos-rebuild switch --flake ~/Dotfiles/nix#dpix720";
    };
    loginShellInit = ''
        if [[ "$(tty)" == "/dev/tty1" ]]; then
          exec Hyprland
        fi
    '';
  };
  
  # Starship prompt configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # One-line minimalist configuration
      add_newline = false;
      format = "$all";
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      
      line_break = {
        disabled = true;
      };
      
      # You can customize other modules as needed
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "blue";
      };
      
      git_branch = {
        format = "[$branch]($style) ";
        style = "green";
      };
      
      # Keep it clean and focused
      kubernetes = { disabled = true; };
      ruby = { disabled = true; };
    };
  };
  
  # Install required packages
  home.packages = with pkgs; [
    fzf
    lsd
    bat
    zoxide
    fd
    eza
  ];
}
