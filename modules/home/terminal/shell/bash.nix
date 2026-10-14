{
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
        [ -z "$1" ] && { echo "Usage: extract <archive>..."; return 1; }
        ouch decompress "$@"
      }

      function compress() {
        [ $# -lt 2 ] && { echo "Usage: compress <files>... <archive.tar.zst|.zip|.7z|...>"; return 1; }
        ouch compress "$@"
      }
    '';
  };
}
