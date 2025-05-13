{ config, pkgs, ... }:

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
        {
          name = "zsh-users/zsh-completions";
          tags = [ "defer:0" ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [ "defer:2" ];
        }
        {
          name = "zsh-users/zsh-history-substring-search";
          tags = [ "defer:2" ];
        }
        {
          name = "Aloxaf/fzf-tab";
          tags = [ "defer:2" ];
        }
      ];
    };

    # Shell history configuration
    history = {
      size = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 5000;
      ignoreDups = true;
    };

    # Keybindings
    initContent = ''
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
    '';

    profileExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
        exec Hyprland
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
      "ff" = "fd … | fzf --preview \" [[ -f {} ]] && bat -f {} || eza -lah --color=always --tree {}\"";
      "hm" = "home-manager switch --flake ~/Dotfiles/home#boi --option substituters true";
      "nu" = "sudo nixos-rebuild switch --flake ~/Dotfiles/nix#dpix720";
    };
  };

  # Ensure required packages are installed
  home.packages = with pkgs; [
    lsd
    bat
    fzf
    zoxide
    fd
    eza
  ];


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
      direnv = { disabled = true; };
      c = { disabled = true; };
      nix_shell = { disabled = true; };
    };
  };
}
