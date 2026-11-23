{
  lib,
  pkgs,
  ...
}: {
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = lib.mkMerge [
        # before the atuin/zoxide/starship hooks, so key bindings can't wipe atuin's ctrl+r
        ''
          set -g fish_greeting

          # fzf.fish ignores FZF_DEFAULT_COMMAND
          set -g fzf_fd_opts --hidden --follow --exclude=.git
          set -g fzf_preview_dir_cmd eza --all --color=always --icons --group-directories-first

          # sponge: don't clean history on startup, only on exit
          set -g sponge_purge_only_on_exit true

          # done: notify only for commands taking longer than 10s
          set -g __done_min_cmd_duration 10000
        ''

        # gruvbox colours (stylix's fish target is off)
        (lib.mkOrder 1100 ''
          set -g fish_color_normal ebdbb2
          set -g fish_color_command b8bb26
          set -g fish_color_quote d3869b
          set -g fish_color_redirection d65d0e
          set -g fish_color_end ffab10
          set -g fish_color_error fb4934
          set -g fish_color_param 83a598
          set -g fish_color_comment 928374
          set -g fish_color_match --background=brblue
          set -g fish_color_selection white --bold --background=brblack
          set -g fish_color_search_match bryellow --background=brblack
          set -g fish_color_history_current --bold
          set -g fish_color_operator 00a6b2
          set -g fish_color_escape 00a6b2
          set -g fish_color_cwd green
          set -g fish_color_cwd_root red
          set -g fish_color_valid_path --underline
          set -g fish_color_autosuggestion 665c54
          set -g fish_color_cancel -r
          set -g fish_color_host normal
          set -g fish_color_status red
          set -g fish_color_user brgreen
          set -g fish_pager_color_completion normal
          set -g fish_pager_color_description yellow --dim
          set -g fish_pager_color_prefix white --bold
        '')
      ];

      # aliases: aliases/
      functions = {
        mkcd = {
          description = "mkdir and cd";
          body = ''
            if test -z "$argv[1]"
              echo "Usage: mkcd <dir>"
              return 1
            end
            mkdir -p $argv[1]; and cd $argv[1]
          '';
        };

        backup = {
          description = "copy file to <file>.bak-<timestamp>";
          body = ''
            if test -z "$argv[1]"
              echo "Usage: backup <file>"
              return 1
            end
            cp $argv[1] $argv[1].bak-(date +%Y%m%d-%H%M%S)
          '';
        };

        # not an alias: fish has no &&-style alias
        mkvenv = {
          description = "create venv and activate it";
          body = ''
            python3 -m venv venv; and source venv/bin/activate.fish
          '';
        };

        gwt = {
          description = "git worktree helper";
          body = ''
            if test (count $argv) -eq 0
              git worktree list
            else
              git worktree add $argv
            end
          '';
        };
      };

      plugins = [
        # old prompt, now starship (terminal/prompt.nix)
        # {
        #   name = "pure";
        #   src = pkgs.fishPlugins.pure.src;
        # }
        # fzf widgets, replaces fzf's own fish integration
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        # notify when a long command finishes
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        # drop failed commands from history
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
      ];
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = false; # handled by fzf.fish plugin
      historyWidget.command = ""; # ctrl+r belongs to atuin

      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
        # colours come from stylix
      ];

      changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
      changeDirWidget.options = ["--preview 'eza --tree --color=always {} | head -200'"];
      fileWidget.command = "fd --type f --hidden --follow --exclude .git";
      fileWidget.options = ["--preview 'bat --color=always --style=numbers --line-range=:500 {}'"];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };

    bat = {
      enable = true;
      config = {
        # theme comes from stylix
        pager = "less -FR";
        style = "numbers,changes,header";
        italic-text = "always";
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = false; # its aliases clash with aliases/
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };

  home.packages = with pkgs; [
    coreutils # `date` in the backup function
  ];
}
