# Charge Grinder: Limbus Company mirror dungeon bot, run from source instead of the AppImage.
# Upstream supports X11 and a few Wayland compositors (sway, Hyprland, KDE, GNOME), not niri,
# so it is run from the sway session (modules/nixos/desktop/sway.nix).
# Update: bump rev/version, set hash = "" and build; nix prints the new hash.
# Pinned to main past v3.5.4 for the "fix graces" commit; go back to `tag` on the next release.
{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  qt6,
  gst_all_1,
  pipewire,
}: let
  python = python3.withPackages (ps:
    with ps; [
      numpy
      opencv4
      pyside6
      xlib
      evdev
      mss
      pygobject3
    ]);
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "charge-grinder";
    version = "3.5.4-unstable-2026-10-20";

    src = fetchFromGitHub {
      owner = "Walpth";
      repo = "Charge-Grinder";
      rev = "fedce87ff1f8c82f01feee3fd6c30b218976f271";
      hash = "sha256-30wfQ9BZnJbMR7sN82XNu2ha+LGPbnsxF8tnA/CaTQw=";
    };

    nativeBuildInputs = [makeWrapper wrapGAppsNoGuiHook gobject-introspection qt6.wrapQtAppsHook];
    # wayland screen capture: portal -> pipewiresrc -> videoconvert -> appsink
    buildInputs = [qt6.qtbase qt6.qtwayland gst_all_1.gstreamer gst_all_1.gst-plugins-base pipewire];

    dontWrapGApps = true;
    dontWrapQtApps = true;

    installPhase = ''
      mkdir -p $out/share/charge-grinder
      cp -r App.py Bot.py stats.py version source source_app ImageAssets $out/share/charge-grinder/
    '';

    # after the hooks have filled gappsWrapperArgs. The env vars are the ones upstream's
    # AppRun sets. From source, game.log/game.csv go next to the code (read-only store) unless
    # APPIMAGE is set, so it points into the data dir; assets don't look at it (source/utils/paths.py)
    # (shell wrapper: the qt hook swaps makeWrapper for the binary one, which has no --run)
    postFixup = ''
      makeShellWrapper ${python.interpreter} $out/bin/charge-grinder \
        "''${gappsWrapperArgs[@]}" "''${qtWrapperArgs[@]}" \
        --add-flags $out/share/charge-grinder/App.py \
        --set QT_QPA_PLATFORM xcb \
        --set QT_XCB_NO_XI2 1 \
        --run 'dir="''${XDG_DATA_HOME:-$HOME/.local/share}/charge-grinder"; mkdir -p "$dir"; cd "$dir"; export APPIMAGE="$dir/charge-grinder"'
    '';

    meta.mainProgram = "charge-grinder";
  })
