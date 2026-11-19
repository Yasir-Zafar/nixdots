# mango (github:mangowm/mango): a dwl-based tiling compositor, dwm tags + awesome-style
# layouts. The flake's module installs mango + mmsg, adds the "Mango" session for the
# greeter and sets mango's portals: gtk for most things, wlr for screencast/screenshot.
# niri.nix stays imported: its session variables, polkit agent and tools are shared,
# and niri stays a session.
# User config (binds, rules, look): modules/home/desktop/mango.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  # screen sharing picker. The portal sends "Monitor: eDP-1 …" and "Window: <title>
  # (<app_id>)" lines; noctalia's launcher shows them as title + subtitle ("Screen eDP-1",
  # "<title>" / "Zen · window"), and the original line goes back to the portal.
  # noctalia's dmenu has no per-line icons, only text.
  sharePicker = pkgs.writeShellApplication {
    name = "share-picker";
    runtimeInputs = [config.programs.noctalia.package pkgs.gnugrep pkgs.gnused pkgs.coreutils];
    text = ''
      # "zen-beta" -> Name= from its .desktop file (by file name or StartupWMClass)
      appname() {
        local app=$1 f
        for dir in /etc/profiles/per-user/"$USER"/share/applications "$HOME"/.nix-profile/share/applications \
          /run/current-system/sw/share/applications "$HOME"/.local/share/flatpak/exports/share/applications \
          /var/lib/flatpak/exports/share/applications; do
          [ -d "$dir" ] || continue
          f="$dir/$app.desktop"
          [ -f "$f" ] || f=$(grep -lix "StartupWMClass=$app" "$dir"/*.desktop 2>/dev/null | head -n1) || true
          if [ -n "$f" ] && [ -f "$f" ]; then
            grep -m1 '^Name=' "$f" | cut -d= -f2-
            return
          fi
        done
        echo "''${app##*.}"
      }

      mapfile -t lines
      display=()
      for l in "''${lines[@]}"; do
        case $l in
          "Monitor: "*)
            rest=''${l#Monitor: }
            name=''${rest%% *}
            d="Screen $name"$'\t'"whole screen"
            ;;
          "Window: "*)
            rest=''${l#Window: }
            if [[ $rest =~ ^(.*)\ \(([^()]*)\)$ ]]; then
              d="''${BASH_REMATCH[1]}"$'\t'"$(appname "''${BASH_REMATCH[2]}") · window"
            else
              d="$rest"$'\t'"window"
            fi
            ;;
          *) d=$l ;;
        esac
        # two windows with the same title: keep the entries apart
        n=1 base=$d
        while printf '%s\n' "''${display[@]}" | grep -qxF -- "$d"; do
          n=$((n + 1))
          d="''${base%%$'\t'*} ($n)"$'\t'"''${base#*$'\t'}"
        done
        display+=("$d")
      done

      sel=$(printf '%s\n' "''${display[@]}" | noctalia dmenu -p Share) || exit 1
      for i in "''${!display[@]}"; do
        if [ "''${display[$i]}" = "$sel" ]; then
          printf '%s\n' "''${lines[$i]}"
          exit 0
        fi
      done
      exit 1
    '';
  };
in {
  programs.mango.enable = true;

  # Without a dmenu-style picker, sharing a single window fails (Discord: error 3002).
  # It has to be set here: NixOS starts the portal with --config=<this>, so a
  # ~/.config/xdg-desktop-portal-wlr/config is never read.
  xdg.portal.wlr.settings.screencast = {
    chooser_type = "dmenu";
    chooser_cmd = lib.getExe sharePicker;
  };
}
