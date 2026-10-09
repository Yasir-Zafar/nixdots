# Navigation, tool replacements, editors, misc (shell-agnostic)
{
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
}
