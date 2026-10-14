# short fastfetch with a small nixos logo, shown when a ghostty window opens
# (alternative: the cat in cat.txt, by jgs (Joan G. Stark) via ascii.co.uk/art/cats)
{lib, ...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "builtin";
        source = "nixos_old_small"; # plain ascii; "NixOS_small" needs block-sextant glyphs
        # type = "file"; source = ./cat.txt;
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
