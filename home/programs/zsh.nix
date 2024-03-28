{

    programs = {

      zsh = {

        enable = true;
        autocd = true;
        dotDir = ".config/zsh";

        historySubstringSearch.enable = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        history.path = "$XDG_DATA_HOME/history";

        shellAliases = {

          ".." = "cd ..";
          ".2" = "cd ../..";
          ".3" = "cd ../../..";
          nu = "sudo nixos-rebuild switch --flake ./.dotfiles/nixos#dpix";
          hu = "home-manager switch --flake ./.dotfiles/home#dpix";
          uu = "nix flake update --accept-flake-config ./.dotfiles/nixos; nix flake update --accept-flake-config ./.dotfiles/home;sudo nixos-rebuild switch --flake ./.dotfiles/nixos#dpix;home-manager switch --flake ./.dotfiles/home#dpix";
          v = "nvim";
          e = "emacs";
          l = "exa -la";
          grep = "grep --color=auto";
          ls   ="exa";
          cat  ="bat --pager=never";
          ip   ="ip -color=auto";
          cp = "cp -i";
          mv = "mv -i";
          rm = "rm -i";
          g = "git";
          gs = "git status";
          db = "clang++ -ggdb -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror -Wshadow -std=c++2b -o";

        };

        profileExtra =
          "# Fixing Paths
           export QT_QPA_PLATFORMTHEME=\"qt5ct\"
           export MOZ_USE_XINPUT2=\"1\" # Mozilla smooth scrolling/touchpads.
           export GTK_THEME=Gruvbox-Dark-B

           export CALIBRE_USE_SYSTEM_THEME=0
           export CALIBRE_USE_DARK_PALETTE=1

           # if login in tty1 (basically the first tty to open) then
           if [[ \"$(tty)\" = \"/dev/tty1\" ]]; then
                   pgrep Hyprland || Hyprland
           fi";

        initExtra = "eval \"$(direnv hook zsh)\"";

    };

  };

}
