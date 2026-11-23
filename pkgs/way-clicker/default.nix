# way-clicker: Qt6 autoclicker, clicks via dotool (daemon: applications/utilities.nix)
# Update: bump rev/version, set hash = "" and build; nix prints the new hash.
{
  lib,
  python3Packages,
  fetchFromCodeberg,
  qt6,
  dotool,
  makeDesktopItem,
  copyDesktopItems,
}:
python3Packages.buildPythonApplication {
  pname = "way-clicker";
  version = "1.0.0-unstable-2026-03-17";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "marvin1099";
    repo = "way-clicker";
    rev = "19caa14c85bef0a4007f9b44c11ef95e3417f7c9";
    hash = "sha256-uq7BDpIHlOhYHTfZ9SFPe6N4hMl815u7V3e0QLJNKbM=";
  };

  build-system = [python3Packages.setuptools];
  dependencies = [python3Packages.pyside6];

  nativeBuildInputs = [qt6.wrapQtAppsHook copyDesktopItems];
  buildInputs = [qt6.qtbase qt6.qtwayland];

  # `--toggle` would start a bare interpreter without the wrapper's env; run the wrapper
  postPatch = ''
    substituteInPlace way_clicker/__main__.py \
      --replace-fail '[sys.executable, "-m", "way_clicker"]' '["'"$out"'/bin/way-clicker"]'
  '';

  # python wrapper does the wrapping; dotoolc must be on PATH for the clicks
  dontWrapQtApps = true;
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [dotool])
  ];
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "way-clicker";
      desktopName = "Way-Clicker";
      comment = "Autoclicker for Wayland and X11";
      exec = "way-clicker";
      icon = "input-mouse";
      categories = ["Utility"];
    })
  ];

  meta = {
    description = "Wayland-aware autoclicker with Qt6 GUI";
    homepage = "https://codeberg.org/marvin1099/way-clicker";
    license = lib.licenses.agpl3Only;
    mainProgram = "way-clicker";
    platforms = lib.platforms.linux;
  };
}
