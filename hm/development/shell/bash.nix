# hm/development/shell/bash.nix
{
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["ignoredups" "ignorespace"];
    historySize = 10000;
    historyFileSize = 10000;

    bashrcExtra = ''
      # Enable vi mode
      set -o vi

      # Better history searching
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      # Case-insensitive completion
      bind 'set completion-ignore-case on'

      # Show all completions immediately
      bind 'set show-all-if-ambiguous on'

      # Color support
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      fi

      # Custom functions
      mkcd() {
          mkdir -p "$1" && cd "$1"
      }

      # Extract function for various archive types
      extract() {
          if [ -f $1 ] ; then
              case $1 in
                  *.tar.bz2)   tar xjf $1     ;;
                  *.tar.gz)    tar xzf $1     ;;
                  *.bz2)       bunzip2 $1     ;;
                  *.rar)       unrar x $1     ;;
                  *.gz)        gunzip $1      ;;
                  *.tar)       tar xf $1      ;;
                  *.tbz2)      tar xjf $1     ;;
                  *.tgz)       tar xzf $1     ;;
                  *.zip)       unzip $1       ;;
                  *.Z)         uncompress $1  ;;
                  *.7z)        7z x $1        ;;
                  *)           echo "'$1' cannot be extracted via extract()" ;;
              esac
          else
              echo "'$1' is not a valid file"
          fi
      }
    '';
  };
}
