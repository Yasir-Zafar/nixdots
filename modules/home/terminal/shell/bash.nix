{config, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = ["ignoredups" "ignorespace"];
    historySize = 10000;
    historyFileSize = 10000;
    historyFile = "${config.xdg.stateHome}/bash/history";

    sessionVariables.HISTTIMEFORMAT = "%F %T ";

    bashrcExtra = ''
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
    '';
  };
}
