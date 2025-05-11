# programs/shells.nix
{ config, lib, pkgs, ... }:

{
  # Enable shells and set defaults
  programs = {
    # Bash configuration
    bash = {
      completion.enable = true;
      enableLsColors = true;
      
      # System-wide bash configuration
      interactiveShellInit = ''
        # Bash history configuration
        export HISTSIZE=50000
        export HISTFILESIZE=50000
        export HISTCONTROL=ignoredups:erasedups
        export HISTIGNORE="ls:cd:exit:clear:history"
        
        # Automatically trim long paths in the prompt
        PROMPT_DIRTRIM=2
        
        # Set a nice prompt
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        
        # Useful aliases
        alias ls='ls --color=auto'
        alias ll='ls -alF'
        alias la='ls -A'
        alias l='ls -CF'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        
        # Git aliases
        alias g='git'
        alias ga='git add'
        alias gc='git commit'
        alias gd='git diff'
        alias gp='git push'
        alias gs='git status'
        
        # Nix shortcuts
        alias nix-search='nix search nixpkgs'
        alias nix-shell='nix-shell --run zsh'
        alias nrs='sudo nixos-rebuild switch'
        alias nrb='sudo nixos-rebuild boot'
        alias nrt='sudo nixos-rebuild test'
        alias hms='home-manager switch'
        
        # Edit files
        alias edit='nano'
        alias vi='vim'
      '';
    };
    
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    
    # StarShip prompt
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
        };
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
    
    # Useful shell tools
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  
  # Set the default shell system-wide
  users.defaultUserShell = pkgs.zsh;
  
  # Install shell utilities
  environment.systemPackages = with pkgs; [
    # Basic shell utilities
    file
    which
    tree
    ripgrep
    fd
    jq
    htop
    btop
    neofetch
    duf
    ncdu
    tldr
    tealdeer
    
    # Command-line tools
    wget
    curl
    git
    gnupg
    unzip
    zip
    p7zip
    unrar
    
    # Advanced tools
    nix-zsh-completions
    nix-bash-completions
    zsh-completions
    zsh-powerlevel10k
    
    # Shell scripting
    shellcheck
    
    # Process management
    lsof
    psmisc
    killall
    
    # Networking
    bind.dnsutils
    inetutils
    traceroute
    whois
    nmap

    neovim
  ];
  
  # Set environment variables for shells
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    BAT_THEME = "TwoDark";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}
