# downloading, torrents, sharing, vpn
{pkgs, ...}: {
  home.packages = with pkgs; [
    yt-dlp
    parabolic
    aria2
    qbittorrent
    fragments
    nicotine-plus
    proton-vpn
    # chromium
  ];
}
