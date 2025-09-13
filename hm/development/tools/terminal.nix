# hm/development/tools/terminal.nix
{
  config,
  pkgs,
  ...
}: {
  # Terminal applications and tools
  home.packages = with pkgs; [
    # System monitoring
    htop
    btop
    iotop

    # File operations
    fd
    ripgrep
    fzf
    tree
    eza # Better ls
    bat # Better cat

    # Network tools
    curl
    wget
    httpie

    # Archive tools
    unzip
    zip
    p7zip

    # Text processing
    jq
    yq

    # System tools
    neofetch
    fastfetch
    du-dust # Better du
    procs # Better ps

    # Development utilities
    just # Command runner
    direnv # Environment management
    nix-direnv
  ];

  programs = {
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
        grep = "ripgrep";
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
        theme = "Catppuccin-mocha";
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
