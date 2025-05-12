{ config, pkgs, lib, ... }:

{
  # Enable Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "archlinux"
      ];
    };

    # zplug configuration
    zplug = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "Aloxaf/fzf-tab"
      ];
    };

    # Shell history configuration
    history = {
      size = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 5000;
      ignoreDups = true;
      shareHistory = true;
    };

    # Keybindings
    initExtra = ''
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
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"

      # Launch Hyprland if not already in a graphical session
      if [ -z "''${DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
        exec wrappedh1
      fi
    '';

    # Aliases
    shellAliases = {
      "l" = "lsd --color=auto --group-dirs=first --blocks=name,git";
      "ll" = "lsd --long --color=auto --group-dirs=first --blocks=date,name,git";
      "la" = "lsd --long --all --color=auto --group-dirs=first --blocks=date,name,git";
      "n" = "nvim";
      "c" = "clear";
      ".." = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      "cat" = "bat --style=plain --paging=never";
      "bat" = "bat --style=grid --theme \"gruvbox-dark\"";
      "gs" = "git status";
      "ga" = "git add";
      "gc" = "git commit";
      "gp" = "git push";
      "gl" = "git log";
      "gco" = "git checkout";
      "gb" = "git branch";
      "ff" = "fd … | fzf --preview \" [[ -f {} ]] && bat -f {} || eza -lah --color=always --tree {}\"";
    };
  };

  # Ensure required packages are installed
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zplug
    lsd
    neovim
    bat
    fzf
    zoxide
    fd
    eza
  ];

  # Oh My Posh configuration
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # You can customize this further or point to your existing config
      config = "$HOME/Dotfiles/config/oh-my-posh/zen.toml";
    };
  };
}
