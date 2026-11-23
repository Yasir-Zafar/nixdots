# claude-desktop: Anthropic's Linux beta, repackaged .deb; no self-update, bump here.
# Update: newest Version/SHA256 in
#   https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages
# (hash: nix hash convert --hash-algo sha256 --to sri <hex>).
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  cups,
  gtk3,
  libdrm,
  libgbm,
  libseccomp,
  libcap_ng,
  libnotify,
  libsecret,
  libuuid,
  libxkbcommon,
  nss,
  nspr,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxtst,
  libxcb,
  libGL,
  libayatana-appindicator,
  pipewire,
  systemd,
  xdg-utils,
}:
stdenv.mkDerivation rec {
  pname = "claude-desktop";
  version = "5.11492.5";

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
    hash = "sha256-uWIIsgfkULdA99vjBPYHf+2A5/PTfd1UWZHE6CAVZM8=";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook makeWrapper];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    cups
    gtk3
    libdrm
    libgbm
    libseccomp # these two: bundled virtiofsd (cowork VM)
    libcap_ng
    libnotify
    libsecret
    libuuid
    libxkbcommon
    nss
    nspr
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxtst
    libxcb
    (lib.getLib pipewire) # claude-native-binding.node (screen capture)
  ];
  # dlopen'd at runtime, so autoPatchelf can't see them (libGL: LD_LIBRARY_PATH below, the GPU process needs it)
  runtimeDependencies = [libayatana-appindicator (lib.getLib systemd)];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r usr/lib usr/share $out/
    # setuid helper can't work from the store; NixOS has unprivileged userns, which chromium uses instead
    rm $out/lib/claude-desktop/chrome-sandbox
    substituteInPlace $out/share/applications/com.anthropic.Claude.desktop \
      --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"
    makeWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      --prefix PATH : ${lib.makeBinPath [xdg-utils]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libGL]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    runHook postInstall
  '';

  meta = {
    description = "Claude desktop app (official Linux beta)";
    homepage = "https://claude.com/download";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "claude-desktop";
  };
}
