# hm/development/shell/aliases.nix
{
  config,
  pkgs,
  ...
}: {
  # Shell aliases for development workflow
  programs.bash.shellAliases = {
    # File operations
    ll = "eza -l --icons";
    la = "eza -la --icons";
    lt = "eza --tree --icons";
    cat = "bat";
    grep = "ripgrep";
    find = "fd";

    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -v";
    gca = "git commit -v -a";
    gcm = "git commit -m";
    gco = "git checkout";
    gcb = "git checkout -b";
    gd = "git diff";
    gp = "git push";
    gpl = "git pull";
    gl = "git log --oneline --graph --decorate";
    gst = "git stash";
    gsp = "git stash pop";

    # System management
    rebuild-nixos = "sudo nixos-rebuild switch --flake ~/nix-config/nixos";
    rebuild-home = "home-manager switch --flake ~/nix-config/hm";
    update-flakes = "nix flake update";

    # Development shortcuts
    n = "nvim";
    code = "code .";
    serve = "python -m http.server 8000";
    myip = "curl ifconfig.me";

    # Java development
    mvnci = "mvn clean install";
    mvnct = "mvn clean test";
    mvncs = "mvn clean spring-boot:run";
    gradle-build = "gradle build";
    gradle-run = "gradle bootRun";

    # Python development
    py = "python3";
    pip = "python3 -m pip";
    venv = "python3 -m venv";
    activate = "source venv/bin/activate";

    # JavaScript development
    ni = "npm install";
    ns = "npm start";
    nt = "npm test";
    nb = "npm run build";
    yi = "yarn install";
    ys = "yarn start";
    yt = "yarn test";
    yb = "yarn build";

    # Navigation shortcuts
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # System monitoring
    top = "btop";
    df = "df -h";
    free = "free -h";
    ps = "procs";

    # Quick edits
    bashrc = "nvim ~/.bashrc";
    nvimrc = "nvim ~/.config/nvim/init.lua";
    nixos-config = "nvim ~/nix-config/nixos/configuration.nix";
    home-config = "nvim ~/nix-config/hm/home.nix";
  };
}
