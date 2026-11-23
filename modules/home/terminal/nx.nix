# nx (update management CLI + TUI, Rust) with its completions; the package is in pkgs/nx
{pkgs, ...}: {
  home.packages = [pkgs.nx];

  # fallback if the Rust build breaks: the bash version
  # home.packages = import ../../../pkgs/nx-sh {inherit pkgs;};
}
