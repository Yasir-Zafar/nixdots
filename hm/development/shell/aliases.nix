{...}: let
  aliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "-" = "cd -";

    # ls → eza
    "l" = "eza --icons --group-directories-first";
    "ll" = "eza --long --all --icons --group-directories-first --git";
    "la" = "eza --all --icons --group-directories-first";
    "lt" = "eza --tree --level=2 --icons";
    "llt" = "eza --tree --long --icons";

    # Safety wrappers
    "cp" = "cp -i";
    "mv" = "mv -i";
    "rm" = "rm -i";
    "mkdir" = "mkdir -pv";
    "diff" = "diff --color=auto";

    # Modern tool replacements
    "cat" = "bat --style=plain --paging=never";
    "less" = "bat --style=full --paging=always";
    "grep" = "rg";
    "find" = "fd";
    "ps" = "procs";
    "du" = "dust";
    "df" = "duf";
    "top" = "btop";

    # Editors
    "n" = "nvim";
    "v" = "nvim";
    "e" = "emacs -nw";

    # Git
    "g" = "git";
    "ga" = "git add";
    "gaa" = "git add --all";
    "gap" = "git add --patch";
    "gc" = "git commit -v";
    "gcm" = "git commit -m";
    "gca" = "git commit -v -a";
    "gcan" = "git commit --amend --no-edit";
    "gco" = "git checkout";
    "gcb" = "git checkout -b";
    "gd" = "git diff";
    "gdc" = "git diff --cached";
    "gl" = "git log --oneline --graph --decorate";
    "gla" = "git log --oneline --graph --decorate --all";
    "gp" = "git push";
    "gpf" = "git push --force-with-lease";
    "gpu" = "git pull";
    "gs" = "git status -sb";
    "gst" = "git stash";
    "gstp" = "git stash pop";
    "gstl" = "git stash list";
    "gf" = "git fetch --all --prune";
    "grb" = "git rebase";
    "grbi" = "git rebase -i";
    "lg" = "lazygit";

    # Nix (via nh)
    "hs" = "nh home switch ~/nix-config/hm";
    "hb" = "nh home build ~/nix-config/hm";
    "ns" = "nh os switch ~/nix-config/nixos";
    "nb" = "nh os build ~/nix-config/nixos";
    "nt" = "nh os test ~/nix-config/nixos";
    "nfu" = "nix flake update --flake ~/nix-config/nixos && nix flake update --flake ~/nix-config/hm";
    "ncg" = "nh clean all";
    "nso" = "nix store optimise";

    # Python
    "py" = "python3";
    "venv" = "source venv/bin/activate";
    "mkvenv" = "python3 -m venv venv && source venv/bin/activate";

    # FZF shortcuts
    "ff" = "fd --type f | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    "fv" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(nvim {})'";

    # Misc
    "c" = "clear";
    "reload" = "exec zsh";
    "path" = "echo -e \${PATH//:/\\n}";
    "myip" = "curl -s https://ipinfo.io/ip";
    "weather" = "curl -s 'https://wttr.in?format=3'";
    "serve" = "python3 -m http.server 8000";
    "pvz" = "docker run --name pvzge -d -p 8080:80 gaozih/pvzge:latest";
  };
in {
  programs.zsh.shellAliases = aliases;
  programs.bash.shellAliases = aliases;
}
