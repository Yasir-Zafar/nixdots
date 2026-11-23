# downloading, torrents, sharing, vpn
{pkgs, ...}: {
  home.packages = with pkgs; [
    yt-dlp
    parabolic
    aria2
    fragments
    qbittorrent
    nicotine-plus
    proton-vpn
  ];
}
