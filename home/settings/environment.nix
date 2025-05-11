# home/settings/environment.nix
{ config, lib, pkgs, ... }:

{
  # Environment variables
  home.sessionVariables = {
    # Editor settings
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    
    # Terminal 
    TERMINAL = "kitty";
    TERM = "xterm-256color";
    
    # Browser
    BROWSER = "firefox";
    
    # Locale
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    
    # Wayland specific
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    CLUTTER_BACKEND = "wayland";
    NIXOS_OZONE_WL = 1;
    
    # Hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    
    # Path additions
    PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
    
    # Less settings
    LESS = "-FR";
    LESSHISTFILE = "-";
    
    # Development
    GOPATH = "$HOME/.go";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
    PNPM_HOME = "$HOME/.local/share/pnpm";
    
    # Other
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude .git";
    DIRENV_LOG_FORMAT = "";
  };
  
  # Add directories to PATH
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.go/bin"
    "$HOME/.local/share/pnpm"
  ];
}
