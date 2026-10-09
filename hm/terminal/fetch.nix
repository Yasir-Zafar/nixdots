# ascii cat by jgs (Joan G. Stark), via ascii.co.uk/art/cats
# short fastfetch with a cat instead of the distro logo, shown when a ghostty window opens
{lib, ...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "file";
        source = ./cat.txt;
        padding.right = 3;
      };

      display.separator = "  ";

      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "shell"
        "wm"
        "cpu"
        "memory"
      ];
    };
  };

  programs.fish.interactiveShellInit = lib.mkAfter ''
    # only in a fresh ghostty window, not inside nvim / nix-shell
    if test "$TERM_PROGRAM" = ghostty; and not set -q NVIM; and not set -q IN_NIX_SHELL
      fastfetch
    end
  '';
}
