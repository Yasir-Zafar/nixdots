{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historySize = 10000;
    historyFileSize = 10000;
    historyFile = "$HOME/.bash_history";

    bashrcExtra = ''
      set -o vi

      bind '"\\e[A": history-search-backward'
      bind '"\\e[B": history-search-forward'
      bind '"\\C-r": reverse-search-history'

      bind 'set completion-ignore-case on'
      bind 'set show-all-if-ambiguous on'
      bind 'set mark-directories on'
      bind 'set mark-symlinked-directories on'
      bind 'set colored-stats on'

      shopt -s checkwinsize
      shopt -s histappend
      shopt -s cmdhist
      shopt -s globstar
      shopt -s cdspell
      shopt -s dirspell

      mkcd() {
          if [ -z "$1" ]; then echo "Usage: mkcd <directory>"; return 1; fi
          mkdir -p "$1" && cd "$1"
      }

      extract() {
          if [ -z "$1" ]; then echo "Usage: extract <archive>"; return 1; fi
          if [ ! -f "$1" ]; then echo "Error: '$1' is not a valid file"; return 1; fi
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

      backup() {
          if [ -z "$1" ]; then echo "Usage: backup <file>"; return 1; fi
          cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
      }

      qfind() { find . -iname "*$1*"; }

      mkexec() {
          if [ -z "$1" ]; then echo "Usage: mkexec <file>"; return 1; fi
          chmod +x "$1"
      }

      showpath() { echo $PATH | tr ':' '\n'; }

      tmpd() {
          local tmpdir=$(mktemp -d)
          echo "Created temporary directory: $tmpdir"
          cd "$tmpdir"
      }
    '';

    initExtra = ''
      if command -v direnv > /dev/null 2>&1; then
          eval "$(direnv hook bash)"
      fi

      if command -v zoxide > /dev/null 2>&1; then
          eval "$(zoxide init bash)"
      fi
    '';

    profileExtra = "";
  };

  home.packages = with pkgs; [
    bash-completion
  ];
}
