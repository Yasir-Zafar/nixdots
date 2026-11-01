# basecamp-linux: unofficial app for Mountain peripherals (Everest 60: RGB only), not in nixpkgs.
# Runs gui.py from source instead of the AppImage, so its self-updater and source overlay
# (both AppImage-only) never patch anything. License: GPL-3 plus a non-commercial clause.
# Device access (udev): modules/nixos/hardware/mountain.nix.
# Update: bump rev/version, set hash = "" and build; nix prints the new hash.
{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
}: let
  python = python3.withPackages (ps:
    with ps; [
      tkinter
      customtkinter
      pillow
      psutil
      obsws-python
      pystray
      hid # the hid.Device flavour, same as the AppImage bundles
      pyusb
    ]);
in
  stdenvNoCC.mkDerivation {
    pname = "basecamp-linux";
    version = "3.1.4";

    src = fetchFromGitHub {
      owner = "ramisotti13-eng";
      repo = "BaseCamp-Linux";
      rev = "d5c654acace7205d862c1ef44a30d3170c6419e6";
      hash = "sha256-t75AxUcRDAhEoMwIdRByNs8Q8vzYnC+VKRpqIUNK9KA=";
    };

    nativeBuildInputs = [makeWrapper copyDesktopItems wrapGAppsHook3 gobject-introspection];
    # tray icon: pystray goes through gi (gtk3 + appindicator typelibs)
    buildInputs = [gtk3 libayatana-appindicator];
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/basecamp-linux
      cp -r . $out/share/basecamp-linux
      install -Dm644 resources/app_icon_256.png $out/share/icons/hicolor/256x256/apps/basecamp-linux.png
      runHook postInstall
    '';

    postFixup = ''
      makeWrapper ${python}/bin/python3 $out/bin/basecamp-linux \
        "''${gappsWrapperArgs[@]}" \
        --add-flags $out/share/basecamp-linux/gui.py
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "basecamp-linux";
        desktopName = "BaseCamp Linux";
        comment = "Mountain keyboard lighting";
        exec = "basecamp-linux";
        icon = "basecamp-linux";
        categories = ["Settings" "HardwareSettings"];
      })
    ];

    meta.mainProgram = "basecamp-linux";
  }
