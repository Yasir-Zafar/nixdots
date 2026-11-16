{
  imports = [
    ./networking.nix
    ./bluetooth.nix
    ./audio.nix
    ./environment.nix
    ./power.nix
    ./compat.nix
    ./syncthing.nix
    ./kdeconnect.nix
    # ./waydroid.nix # off for now; module kept
    # ./omnisearch.nix # off; package and module kept
  ];
}
