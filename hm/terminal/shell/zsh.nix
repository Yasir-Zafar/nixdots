{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true; # Native HM flag (handles zsh-autosuggestions)

    # --- Plugins ---
    # Sourced safely via Nix packages. Order is maintained:
    # Completions -> Framework Hooks -> Mid-tier logic -> Syntax Highlighting last.
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    # --- History Configuration ---
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

    # --- Interactive Shell Customization (.zshrc changes) ---
    initContent = ''
      # --- Prompt Layout ---
      # No framework dependencies.
      # %B...%b (bold), %F{color}...%f (foreground), %~ (CWD), %(?.success.fail) (exit evaluation)
      setopt PROMPT_SUBST
      PS1='%B%F{blue}%~%f%b %(?.%F{green}❯%f.%F{red}❯%f) '

      # --- Keybindings & Substring Navigation ---
      bindkey '^p'   history-substring-search-up
      bindkey '^n'   history-substring-search-down
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # --- Core Shell Options ---
      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
      setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD LIST_PACKED
      setopt HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY
      setopt CORRECT EXTENDED_GLOB GLOB_DOTS

      # --- Tab Completion System Styles ---
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "$\{(s.:.)LS_COLORS}"
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' menu no
      zstyle ':completion:*' use-cache true
      zstyle ':completion:*' cache-path "$HOME/.zcompcache"
      zstyle ':completion:*:descriptions' format '%B%d%b'
      zstyle ':completion:*' group-name ""

      # --- Advanced fzf-tab Interactive Previews ---
      zstyle ':fzf-tab:complete:cd:*'                fzf-preview 'eza -1 --color=always --icons $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*'        fzf-preview 'eza -1 --color=always --icons $realpath'
      zstyle ':fzf-tab:complete:kill:argument-rest'  fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:kill:argument-rest'  fzf-flags '--preview-window=down:3:wrap'

      # --- Inline Autosuggestions Settings ---
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

      # --- External Credentials / Overrides Hook ---
      [[ -f ~/.zsh_private ]] && source ~/.zsh_private
    '';
  };
}
