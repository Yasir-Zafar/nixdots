{...}: let
  aliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # ls -> eza
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
    "hs" = "nh home switch ~/dots/hm";
    "hb" = "nh home build ~/dots/hm";
    "ns" = "nh os switch ~/dots/nix";
    "nb" = "nh os build ~/dots/nix";
    "nt" = "nh os test ~/dots/nix";
    "nfu" = "nix flake update --flake ~/dots/nix && nix flake update --flake ~/dots/hm";
    "ncg" = "nh clean all";
    "nso" = "nix store optimise";

    # Python
    "py" = "python3";
    "serve" = "python3 -m http.server 8000";

    # FZF shortcuts
    "ff" = "fd --type f | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    "fv" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(nvim {})'";

    # Misc
    "c" = "clear";
    "myip" = "curl -s https://ipinfo.io/ip";
    "weather" = "curl -s 'https://wttr.in?format=3'";
    "pvz" = "docker run --name pvzge -d -p 8080:80 gaozih/pvzge:latest";
  };

  # overrides for entries that are bash/zsh-specific
  fishOverrides = {
    # 'cd -' is not valid in fish; prevd is the equivalent
    # reload fish (not zsh)
    "reload" = "exec fish";

    # fish PATH is a list; just print it
    "path" = "string join \\n $PATH";

    # venv activate uses the fish-specific script
    "venv" = "source venv/bin/activate.fish";

    # mkvenv: && is not fish syntax; defined as a function in fish.nix instead
    # (omitted here so it doesn't land as a broken alias)
  };

  posixOverrides = {
    "-" = "cd -";
    "reload" = "exec zsh";
    "path" = "echo -e \${PATH//:/\\n}";
    "venv" = "source venv/bin/activate";
    "mkvenv" = "python3 -m venv venv && source venv/bin/activate";
  };
in {
  programs.zsh.shellAliases = aliases // posixOverrides;
  programs.bash.shellAliases = aliases // posixOverrides;
  programs.fish.shellAliases = aliases // fishOverrides;
}
