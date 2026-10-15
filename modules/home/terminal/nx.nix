# nx (update management CLI + TUI, Rust) with its completions; the package is in pkgs/nx
{pkgs, ...}: {
  home.packages = [(pkgs.callPackage ../../../pkgs/nx {})];

  # the bash version (pkgs/nx-sh, one file per command) is the fallback: swap the line
  # above for this one if the Rust build ever breaks
  # home.packages = import ../../../pkgs/nx-sh {inherit pkgs;};
}
