# nx: update management for ~/dots (Rust): rebuilds through nh, reports (status, apps,
# storage, doctor, generations) and a TUI (`nx tui`). See docs/USAGE.md §5.
# The programs it drives are put on its PATH by the wrapper; systemctl, journalctl, sudo,
# docker and flatpak come from the system PATH.
# The bash version it replaced is kept in ../nx-sh.
{
  lib,
  rustPlatform,
  makeWrapper,
  installShellFiles,
  nh,
  nix,
  nvd,
  git,
  statix,
  deadnix,
  alejandra,
  coreutils,
  procps,
  home-manager,
  fwupd,
  jq,
}:
rustPlatform.buildRustPackage {
  pname = "nx";
  version = (lib.importTOML ./Cargo.toml).package.version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [./Cargo.toml ./Cargo.lock ./src];
  };
  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [makeWrapper installShellFiles];

  postInstall = ''
    wrapProgram $out/bin/nx --prefix PATH : ${lib.makeBinPath [nh nix nvd git statix deadnix alejandra coreutils procps home-manager fwupd]}
    for f in ${./completions/nx.fish} ${./completions/_nx}; do
      substitute "$f" "$(basename "$f" | sed 's/^[a-z0-9]*-//')" --replace-fail @jq@ ${lib.getExe jq}
    done
    installShellCompletion --cmd nx --fish nx.fish --zsh _nx
  '';

  meta = {
    description = "Update management for ~/dots, with a TUI";
    mainProgram = "nx";
    platforms = lib.platforms.linux;
  };
}
