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
        nu = "sudo nixos-rebuild switch --flake .!/.dots/nix#dpix";
        hu = "home-manager switch --flake .~/.dots/home-manager#boi@dpix";
        uu = "nix fmt; nix flake update --accept-flake-config .~/.dots/nix; sudo nixos-rebuild switch --flake ./.dots#dpix; home-manager switch --flake ./.dots#boi@dpix";
        v = "nvim";
        e = "emacs";
        l = "exa -la";
        grep = "grep --color=auto";
        ls = "exa";
        cat = "bat --pager=never";
        ip = "ip -color=auto";
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";
        db = "clang++ -ggdb -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror -Wshadow -std=c++2b -o";
      };

      profileExtra = "# if login in tty1 (basically the first tty to open) then
           if [[ \"$(tty)\" = \"/dev/tty1\" ]]; then
                   pgrep Hyprland || Hyprland
           fi";

      initExtra = "eval \"$(direnv hook zsh)\"";
    };
  };
}
