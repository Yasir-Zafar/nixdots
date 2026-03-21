{pkgs, ...}: {
  home.packages = with pkgs; [
    sqlite
    sqlite-analyzer
    sqlitebrowser
  ];
}
