{
  imports = [
    ./nixvim # day-to-day editor
    ./jetbrains.nix
    ./vscode.nix
    ./emacs # Emacs 31, stock keys, everything declared (emacs/default.nix)
    # ./emacs.nix # the old Doom-style setup, kept for reference
  ];
}
