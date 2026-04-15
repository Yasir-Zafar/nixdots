{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    # ----------------------------------------------------------------- #
    # PLUGINS                                                             #
    # Sourced from nixpkgs at build time — no runtime fetching (zplug    #
    # removed). Order matters: completions first, then fzf-tab (needs    #
    # compsys loaded), then syntax highlighting last.                     #
    # ----------------------------------------------------------------- #
    plugins = [
      {
        name = "zsh-completions";
        src = "${pkgs.zsh-completions}/share/zsh/site-functions";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-history-substring-search";
        src = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search";
      }
      {
        name = "zsh-autosuggestions";
        src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      }
      {
        # must be last
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
    ];

    # ----------------------------------------------------------------- #
    # HISTORY                                                             #
    # ----------------------------------------------------------------- #
    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
    };

    defaultKeymap = "emacs";

    # ----------------------------------------------------------------- #
    # INIT                                                                #
    # zoxide / direnv / fzf hooks are injected by their own HM program   #
    # blocks (enableZshIntegration = true on each). Only zsh-specific    #
    # config lives here.                                                  #
    # ----------------------------------------------------------------- #
    initContent = ''
      # --- prompt ---
      # plain zsh, no framework.
      # %F{color}...%f wraps color, %B...%b is bold
      # %~ = cwd with ~ abbreviation, %(?.x.y) = branch on last exit code
      setopt PROMPT_SUBST
      PS1='%B%F{blue}%~%f%b %(?.%F{green}❯%f.%F{red}❯%f) '

      # --- keybindings ---
      bindkey '^p'   history-substring-search-up
      bindkey '^n'   history-substring-search-down
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # --- options ---
      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
      setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD LIST_PACKED
      setopt HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY
      setopt CORRECT EXTENDED_GLOB GLOB_DOTS

      # --- completion ---
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' menu no
      zstyle ':completion:*' use-cache true
      zstyle ':completion:*' cache-path "$HOME/.zcompcache"
      zstyle ':completion:*:descriptions' format '%B%d%b'
      zstyle ':completion:*' group-name '''

      # --- fzf-tab previews ---
      zstyle ':fzf-tab:complete:cd:*'               fzf-preview 'eza -1 --color=always --icons $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*'       fzf-preview 'eza -1 --color=always --icons $realpath'
      zstyle ':fzf-tab:complete:kill:argument-rest'  fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:kill:argument-rest'  fzf-flags '--preview-window=down:3:wrap'

      # --- autosuggestions ---
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

      [[ -f ~/.zsh_private ]] && source ~/.zsh_private
    '';
  };
}
