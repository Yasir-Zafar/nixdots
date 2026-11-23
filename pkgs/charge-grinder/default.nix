# Charge Grinder (Limbus bot) from source; X11 backend only, so run it from the bspwm session
# Update: bump tag/version, set hash = "" and build; nix prints the new hash.
{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  qt6,
}: let
  python = python3.withPackages (ps:
    with ps; [
      numpy
      opencv4
      pyside6
      xlib
      evdev
      mss
    ]);
in
  stdenvNoCC.mkDerivation (_finalAttrs: {
    pname = "charge-grinder";
    version = "3.6.1";

    src = fetchFromGitHub {
      owner = "Walpth";
      repo = "Charge-Grinder";
      tag = "v3.6.1";
      hash = "sha256-WDMdQg2+O9mkLhKgX+qAW1zyb9Gwdd4uSF3BbVjqehY=";
    };

    nativeBuildInputs = [makeWrapper qt6.wrapQtAppsHook];
    buildInputs = [qt6.qtbase];

    dontWrapQtApps = true;

    installPhase = ''
      mkdir -p $out/share/charge-grinder
      cp -r App.py Bot.py stats.py version source source_app ImageAssets $out/share/charge-grinder/
    '';

    # after the qt hook fills qtWrapperArgs; env vars as upstream's AppRun, logs into the data dir, x11 backend always
    postFixup = ''
      makeShellWrapper ${python.interpreter} $out/bin/charge-grinder \
        "''${qtWrapperArgs[@]}" \
        --add-flags $out/share/charge-grinder/App.py \
        --set QT_QPA_PLATFORM xcb \
        --set QT_XCB_NO_XI2 1 \
        --set XDG_SESSION_TYPE x11 \
        --run 'dir="''${XDG_DATA_HOME:-$HOME/.local/share}/charge-grinder"; mkdir -p "$dir"; cd "$dir"; export APPIMAGE="$dir/charge-grinder"'
    '';

    meta.mainProgram = "charge-grinder";
  })
