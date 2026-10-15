# nx (update management CLI) and its completions; the package is in pkgs/nx-sh
{pkgs, ...}: {
  home.packages = import ../../../pkgs/nx-sh {inherit pkgs;};
}
