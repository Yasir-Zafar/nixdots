# nx (update management CLI) and its completions; the package is in pkgs/nx
{pkgs, ...}: {
  home.packages = import ../../../pkgs/nx {inherit pkgs;};
}
