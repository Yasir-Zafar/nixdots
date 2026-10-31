# omnisearch metasearch engine on http://localhost:8087 (localhost only, no firewall port)
{pkgs, ...}: let
  omnisearch = pkgs.callPackage ../../../pkgs/omnisearch {};

  config = pkgs.writeText "config.ini" ''
    [server]
    host = 127.0.0.1
    port = 8087

    [cache]
    dir = /var/cache/omnisearch

    [engines]
    engines = "ddg,startpage"
  '';

  # it reads config.ini, templates/, static/ and locales/ from its working directory
  workdir = pkgs.runCommand "omnisearch-workdir" {} ''
    mkdir $out
    ln -s ${omnisearch}/share/omnisearch/* $out/
    ln -s ${config} $out/config.ini
  '';
in {
  systemd.services.omnisearch = {
    description = "OmniSearch metasearch engine";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${omnisearch}/bin/omnisearch";
      WorkingDirectory = workdir;
      DynamicUser = true;
      CacheDirectory = "omnisearch";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
