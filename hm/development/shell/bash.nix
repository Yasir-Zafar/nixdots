{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = ["ignoredups" "ignorespace"];
    historySize = 10000;
    historyFileSize = 10000;

    sessionVariables = {
      HISTCONTROL = "ignoreboth";
      HISTSIZE = "10000";
      HISTFILESIZE = "10000";
      HISTTIMEFORMAT = "%F %T ";
    };

    bashrcExtra = ''
      set -o vi

      bind '"\\e[A": history-search-backward'
      bind '"\\e[B": history-search-forward'
      bind 'set completion-ignore-case on'
      bind 'set show-all-if-ambiguous on'
      bind 'set colored-stats on'

      shopt -s checkwinsize histappend cmdhist globstar cdspell dirspell

      function mkcd() {
        [ -z "$1" ] && { echo "Usage: mkcd <dir>"; return 1; }
        mkdir -p "$1" && cd "$1"
      }

      function extract() {
        [ -z "$1" ]   && { echo "Usage: extract <archive>"; return 1; }
        [ ! -f "$1" ] && { echo "Not a file: $1"; return 1; }
        case $1 in
          *.tar.bz2) tar xjf "$1" ;; *.tar.gz)  tar xzf "$1" ;;
          *.tar.xz)  tar xJf "$1" ;; *.bz2)     bunzip2 "$1" ;;
          *.rar)     unrar x "$1" ;; *.gz)       gunzip  "$1" ;;
          *.tar)     tar xf  "$1" ;; *.zip)      unzip   "$1" ;;
          *.7z)      7z x    "$1" ;;
          *) echo "Don't know how to extract '$1'" ;;
        esac
      }
    '';

    initExtra = ''
      eval "$(${pkgs.fzf}/bin/fzf --bash)"
      eval "$(${pkgs.zoxide}/bin/zoxide init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}
