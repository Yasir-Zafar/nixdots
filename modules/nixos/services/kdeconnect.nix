# phone integration via Valent (GTK client for the KDE Connect protocol; autostarts from its own
# xdg entry). Opens tcp/udp 1714-1764 (networking.nix lists the same range) and enables uinput
{pkgs, ...}: {
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };
}
