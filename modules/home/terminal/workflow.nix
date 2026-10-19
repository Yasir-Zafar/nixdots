# terminal workflow: history, multiplexer, git ui, file manager
# The zellij "dev" workspace (tabs: nvim, claude, git, term) is described in docs/WORKFLOW.md
{
  lib,
  pkgs,
  ...
}: let
  # nvim publishes its socket here (nixvim/plugins/workflow.nix) so other tabs can open files in it
  sock = ''"''${XDG_RUNTIME_DIR:-/tmp}/zellij-dev/''${ZELLIJ_SESSION_NAME:-none}/nvim.sock"'';

  # dev [dir]: open (or reattach to) the workspace of a project, one session per git root
  dev = pkgs.writeShellApplication {
    name = "dev";
    runtimeInputs = [pkgs.zellij pkgs.git pkgs.coreutils pkgs.gnugrep];
    text = ''
      if [ -n "''${ZELLIJ:-}" ]; then
        echo "dev: already inside zellij (session $ZELLIJ_SESSION_NAME)" >&2
        exit 1
      fi
      cd "''${1:-.}"
      root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      cd "$root"
      name=$(basename "$root" | tr -c 'A-Za-z0-9_\n-' '_')
      if zellij list-sessions --short --no-formatting 2>/dev/null | grep -qxF "$name"; then
        exec zellij attach --force-run-commands "$name"
      fi
      exec zellij --new-session-with-layout dev --session "$name"
    '';
  };

  # zj-edit FILE [LINE]: open FILE in the workspace's nvim and switch to its tab (lazygit's `e`);
  # without a running nvim it simply runs nvim here
  zj-edit = pkgs.writeShellApplication {
    name = "zj-edit";
    text = ''
      # absolute: the nvim server resolves relative names against its own cwd, not lazygit's
      file=$(realpath -m -- "$1")
      line=''${2:-1}
      sock=${sock}
      if [ -n "''${ZELLIJ:-}" ] && [ -S "$sock" ] && nvim --server "$sock" --remote-expr 1 >/dev/null 2>&1; then
        nvim --server "$sock" --remote "$file"
        nvim --server "$sock" --remote-expr "cursor($line, 1)" >/dev/null
        zellij action go-to-tab-name nvim || true
        exit 0
      fi
      exec nvim "+$line" "$file"
    '';
  };

  # claude-ide: `claude --ide`, started once this workspace's nvim has published its IDE lock file
  # (so diffs and selection are connected from the first prompt)
  claude-ide = pkgs.writeShellApplication {
    name = "claude-ide";
    runtimeInputs = [pkgs.coreutils pkgs.gnugrep];
    text = ''
      for _ in $(seq 20); do
        grep -qsF "\"$PWD\"" "''${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/ide/*.lock && break
        sleep 0.25
      done
      exec claude --ide "$@"
    '';
  };
in {
  home.packages = [dev zj-edit claude-ide];

  programs = {
    atuin = {
      enable = true;
      # keep up-arrow for normal history, atuin on ctrl+r
      flags = ["--disable-up-arrow"];
    };

    # plain `zellij` stays a blank session; `dev` opens the project workspace (layout below)
    zellij = {
      enable = true;
      settings = {
        # $SHELL is zsh (the login shell; ghostty only launches fish), so without this the panes open zsh
        default_shell = "fish";
        # locked = every key goes to the app in the pane (nvim, lazygit and claude all use
        # ctrl chords zellij would steal); zellij itself is driven by the Alt layer below
        default_mode = "locked";
        copy_command = "wl-copy";
        scroll_buffer_size = 20000;
        show_startup_tips = false;
        show_release_notes = false;
        theme = "gruvbox-dark"; # built into zellij (stylix's zellij target is off)
        pane_frames = false; # one program per tab: the tab bar already names it
      };

      extraConfig = ''
        keybinds {
          // ctrl+g is claude's "edit prompt in $EDITOR"; alt+space is the zellij lock toggle instead
          unbind "Ctrl g"
          locked {
            bind "Alt Space" { SwitchToMode "Normal"; }
          }
          shared_except "locked" {
            bind "Alt Space" { SwitchToMode "Locked"; }
          }

          // the Alt layer: always active, also while locked
          shared {
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
            bind "Alt 5" { GoToTab 5; }
            bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
            bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
            bind "Alt j" "Alt Down" { MoveFocus "Down"; }
            bind "Alt k" "Alt Up" { MoveFocus "Up"; }
            bind "Alt f" { ToggleFloatingPanes; }
            bind "Alt z" { ToggleFocusFullscreen; }
            bind "Alt n" { NewPane; }
            bind "Alt =" "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
          }

          // after alt+space: one key per zellij mode; esc / alt+space locks again
          normal {
            bind "Esc" { SwitchToMode "Locked"; }
            bind "p" { SwitchToMode "Pane"; }
            bind "t" { SwitchToMode "Tab"; }
            bind "r" { SwitchToMode "Resize"; }
            bind "s" { SwitchToMode "Scroll"; }
            bind "o" { SwitchToMode "Session"; }
            bind "m" { SwitchToMode "Move"; }
            bind "n" { NewPane; SwitchToMode "Locked"; }
            bind "c" { NewTab; SwitchToMode "Locked"; }
            bind "x" { CloseFocus; SwitchToMode "Locked"; }
            bind "d" { Detach; }
          }
        }
      '';

      layouts.dev = ''
        layout {
          default_tab_template {
            pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
              plugin location="zellij:status-bar"
            }
          }

          tab name="nvim" focus=true {
            pane command="nvim"
          }
          tab name="claude" {
            pane command="claude-ide"
          }
          tab name="git" {
            pane command="lazygit"
          }
          tab name="term"
        }
      '';
    };

    lazygit = {
      enable = true; # `lg` alias lives in shell/aliases/git.nix
      settings = {
        gui.nerdFontsVersion = "3";
        # `e` opens the file in the workspace's nvim tab instead of inside lazygit
        os = {
          edit = "${lib.getExe zj-edit} {{filename}}";
          editAtLine = "${lib.getExe zj-edit} {{filename}} {{line}}";
        };
      };
    };

    # yazi: faster terminal file manager with previews (images in ghostty, pdf, video);
    # `y` opens it and cds to wherever you quit. Colours and icons come from stylix
    # (gruvbox-dark-medium); the rest of the look is added here: rounded full border,
    # git status next to files, size + mtime column, a wider preview pane.
    yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        inherit (pkgs.yaziPlugins) full-border git;
      };
      initLua = ''
        require("full-border"):setup { type = ui.Border.ROUNDED }
        require("git"):setup()
      '';
      # square ends on the hovered row instead of the default rounded pill
      theme.indicator.padding = {
        open = "▐";
        close = "▌";
      };
      settings = {
        mgr = {
          show_hidden = false;
          sort_dir_first = true;
          ratio = [1 3 4]; # parent / current / preview
          linemode = "size";
        };
        plugin.prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
    };
  };
}
