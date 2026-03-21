# ============================================================================
# Bash Shell Configuration
# Location: hm/development/shell/bash.nix
# ============================================================================
{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # ========================================================================
    # HISTORY CONFIGURATION
    # ========================================================================
    historyControl = [
      "ignoredups" # Don't record duplicate commands
      "ignorespace" # Don't record commands starting with space
    ];
    historySize = 10000; # Number of commands in memory
    historyFileSize = 10000; # Number of commands in history file

    # ========================================================================
    # HISTORY FILE LOCATION
    # ========================================================================
    historyFile = "$HOME/.bash_history";

    # ========================================================================
    # BASH CONFIGURATION
    # ========================================================================
    bashrcExtra = ''
      # ======================================================================
      # VI MODE
      # ======================================================================
      # Enable vi keybindings in bash
      set -o vi

      # ======================================================================
      # IMPROVED HISTORY SEARCH
      # ======================================================================
      # Use arrow keys to search through history
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      # Ctrl+R for reverse search (default, but explicit)
      bind '"\C-r": reverse-search-history'

      # ======================================================================
      # COMPLETION SETTINGS
      # ======================================================================
      # Case-insensitive completion
      bind 'set completion-ignore-case on'

      # Show all completions immediately (no double-tab needed)
      bind 'set show-all-if-ambiguous on'

      # Append slash to directory completions
      bind 'set mark-directories on'
      bind 'set mark-symlinked-directories on'

      # Color completion matches
      bind 'set colored-stats on'

      # ======================================================================
      # SHELL OPTIONS
      # ======================================================================
      # Check window size after each command
      shopt -s checkwinsize

      # Append to history file, don't overwrite
      shopt -s histappend

      # Save multi-line commands as single entry
      shopt -s cmdhist

      # Enable recursive globbing with **
      shopt -s globstar

      # Correct minor directory spelling errors
      shopt -s cdspell
      shopt -s dirspell

      # ======================================================================
      # COLOR SUPPORT
      # ======================================================================
      # Enable color support for ls and other commands
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      fi

      # ======================================================================
      # CUSTOM FUNCTIONS
      # ======================================================================

      # Create directory and cd into it
      mkcd() {
          if [ -z "$1" ]; then
              echo "Usage: mkcd <directory>"
              return 1
          fi
          mkdir -p "$1" && cd "$1"
      }

      # Extract various archive formats
      extract() {
          if [ -z "$1" ]; then
              echo "Usage: extract <archive>"
              return 1
          fi

          if [ ! -f "$1" ]; then
              echo "Error: '$1' is not a valid file"
              return 1
          fi

          case $1 in
              *.tar.bz2)   tar xjf "$1"    ;;
              *.tar.gz)    tar xzf "$1"    ;;
              *.tar.xz)    tar xJf "$1"    ;;
              *.bz2)       bunzip2 "$1"    ;;
              *.rar)       unrar x "$1"    ;;
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

      # Backup a file with timestamp
      backup() {
          if [ -z "$1" ]; then
              echo "Usage: backup <file>"
              return 1
          fi
          cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
      }

      # Quick file search in current directory
      qfind() {
          find . -iname "*$1*"
      }

      # Make executable
      mkexec() {
          if [ -z "$1" ]; then
              echo "Usage: mkexec <file>"
              return 1
          fi
          chmod +x "$1"
      }

      # Show PATH in readable format
      showpath() {
          echo $PATH | tr ':' '\n'
      }

      # Quick git commit with message
      gcm() {
          if [ -z "$1" ]; then
              echo "Usage: gcm <commit message>"
              return 1
          fi
          git add -A && git commit -m "$1"
      }

      # Create and enter a temporary directory
      tmpd() {
          local tmpdir=$(mktemp -d)
          echo "Created temporary directory: $tmpdir"
          cd "$tmpdir"
      }

      # ======================================================================
      # PROMPT CUSTOMIZATION (Optional - use Starship instead)
      # ======================================================================
      # Uncomment if not using Starship or another prompt tool
      # PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    '';

    # ========================================================================
    # INITIALIZATION COMMANDS
    # ========================================================================
    initExtra = ''
      # Run at the start of interactive sessions

      # Optional: Display system info on shell start
      # ${pkgs.fastfetch}/bin/fastfetch

      # Optional: Load direnv if available
      if command -v direnv > /dev/null 2>&1; then
          eval "$(direnv hook bash)"
      fi

      # Optional: Initialize zoxide (better cd)
      if command -v zoxide > /dev/null 2>&1; then
          eval "$(zoxide init bash)"
      fi
    '';

    # ========================================================================
    # PROFILE EXTRA (Login shells)
    # ========================================================================
    profileExtra = ''
      # Commands to run in login shells

      # Add any login-specific initialization here
    '';
  };

  # ==========================================================================
  # BASH-RELATED PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    bash-completion # Additional bash completions
    # blesh # Bash Line Editor (advanced bash experience)
  ];
}
# ============================================================================
# BASH CONFIGURATION NOTES
# ============================================================================
# 1. Vi Mode: Press ESC to enter command mode, i for insert mode
# 2. History Search: Use arrow keys after typing partial command
# 3. Functions: All custom functions are available in your shell
# 4. Consider using Zsh if you want more advanced features
# 5. Consider using Starship for a better prompt experience
# ============================================================================

