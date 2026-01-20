# ============================================================================
# Shell Aliases Configuration
# Location: hm/development/shell/aliases.nix
# ============================================================================
{pkgs, ...}: {
  programs.bash.shellAliases = {
    # ========================================================================
    # FILE OPERATIONS (Modern Alternatives)
    # ========================================================================
    # Better file listing with eza (modern ls replacement)
    ll = "eza -l --icons"; # Long format with icons
    la = "eza -la --icons"; # All files including hidden
    lt = "eza --tree --icons"; # Tree view
    ls = "eza --icons"; # Basic listing

    # Better file viewing
    cat = "bat"; # Syntax-highlighted cat
    less = "bat --paging=always"; # Better pager

    # Better search tools
    grep = "rg"; # ripgrep (faster grep)
    find = "fd"; # fd (faster find)

    # Modern du alternative
    du = "dust"; # Disk usage with tree view

    # ========================================================================
    # GIT SHORTCUTS
    # ========================================================================
    # Basic git operations
    g = "git";
    gs = "git status";
    gss = "git status -s"; # Short status

    # Adding files
    ga = "git add";
    gaa = "git add --all";
    gap = "git add --patch"; # Interactive staging

    # Committing
    gc = "git commit -v";
    gca = "git commit -v -a";
    gcm = "git commit -m";
    gcam = "git commit -a -m";
    gcan = "git commit --amend --no-edit";

    # Branching
    gco = "git checkout";
    gcb = "git checkout -b";
    gb = "git branch";
    gba = "git branch -a";
    gbd = "git branch -d";

    # Diffing
    gd = "git diff";
    gdc = "git diff --cached";
    gdw = "git diff --word-diff";

    # Pushing & Pulling
    gp = "git push";
    gpf = "git push --force-with-lease"; # Safer force push
    gpl = "git pull";
    gplr = "git pull --rebase";

    # Logging
    gl = "git log --oneline --graph --decorate";
    gla = "git log --oneline --graph --decorate --all";
    glp = "git log --patch"; # Show diff in log

    # Stashing
    gst = "git stash";
    gsta = "git stash apply";
    gstl = "git stash list";
    gstp = "git stash pop";
    gstd = "git stash drop";

    # Remote operations
    gf = "git fetch";
    gfa = "git fetch --all";
    grb = "git rebase";
    grbi = "git rebase -i";

    # Cleanup
    gclean = "git clean -fd";
    greset = "git reset --hard HEAD";

    # ========================================================================
    # NIXOS SYSTEM MANAGEMENT
    # ========================================================================
    # NixOS rebuilds
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
    rebuild-test = "sudo nixos-rebuild test --flake ~/dotfiles";
    rebuild-boot = "sudo nixos-rebuild boot --flake ~/dotfiles";

    # Home Manager
    hm = "home-manager switch --flake ~/dotfiles";
    hm-test = "home-manager build --flake ~/dotfiles";

    # Flake operations
    update-flakes = "nix flake update ~/dotfiles";
    update-all = "cd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake .";

    # Nix utilities
    nix-clean = "nix-collect-garbage -d";
    nix-clean-all = "sudo nix-collect-garbage -d";
    nix-optimize = "nix-store --optimize";
    nix-search = "nix search nixpkgs";

    # ========================================================================
    # DEVELOPMENT SHORTCUTS
    # ========================================================================
    # Editor shortcuts
    n = "nvim";
    v = "nvim";
    vim = "nvim";

    # Quick server
    serve = "python -m http.server 8000";
    serve-php = "php -S localhost:8000";

    # Network utilities
    myip = "curl ifconfig.me";
    localip = "ip addr show | grep 'inet ' | grep -v 127.0.0.1";
    ports = "netstat -tulanp";

    # ========================================================================
    # JAVA DEVELOPMENT
    # ========================================================================
    # Maven shortcuts
    mvn-clean = "mvn clean";
    mvn-install = "mvn clean install";
    mvn-test = "mvn clean test";
    mvn-package = "mvn clean package";
    mvn-run = "mvn spring-boot:run";
    mvn-skip-tests = "mvn clean install -DskipTests";

    # Gradle shortcuts
    gw = "./gradlew"; # Gradle wrapper
    gradle-build = "gradle build";
    gradle-run = "gradle bootRun";
    gradle-test = "gradle test";
    gradle-clean = "gradle clean";

    # ========================================================================
    # PYTHON DEVELOPMENT
    # ========================================================================
    # Python shortcuts
    py = "python3";
    python = "python3";
    pip = "python3 -m pip";

    # Virtual environment
    venv-create = "python3 -m venv venv";
    venv = "source venv/bin/activate";
    activate = "source venv/bin/activate";
    deactivate-venv = "deactivate";

    # Package management
    pip-install = "pip install -r requirements.txt";
    pip-freeze = "pip freeze > requirements.txt";
    pip-upgrade = "pip install --upgrade pip";

    # Poetry
    poetry-install = "poetry install";
    poetry-shell = "poetry shell";
    poetry-run = "poetry run python";

    # ========================================================================
    # JAVASCRIPT DEVELOPMENT
    # ========================================================================
    # npm shortcuts
    ni = "npm install";
    nid = "npm install --save-dev";
    nis = "npm install --save";
    ns = "npm start";
    nt = "npm test";
    nr = "npm run";
    nb = "npm run build";
    nw = "npm run watch";

    # yarn shortcuts
    yi = "yarn install";
    ya = "yarn add";
    yad = "yarn add --dev";
    ys = "yarn start";
    yt = "yarn test";
    yr = "yarn run";
    yb = "yarn build";

    # pnpm shortcuts
    pn = "pnpm";
    pni = "pnpm install";
    pna = "pnpm add";
    pns = "pnpm start";
    pnt = "pnpm test";
    pnr = "pnpm run";

    # ========================================================================
    # DOCKER SHORTCUTS
    # ========================================================================
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    dpsa = "docker ps -a";
    di = "docker images";
    dex = "docker exec -it";
    dlogs = "docker logs -f";
    dstop = "docker stop";
    drm = "docker rm";
    drmi = "docker rmi";
    dprune = "docker system prune -a";

    # ========================================================================
    # NAVIGATION SHORTCUTS
    # ========================================================================
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";

    # Quick navigation (requires zoxide or autojump)
    # z = "zoxide"; # Uncomment if using zoxide

    # ========================================================================
    # SYSTEM MONITORING
    # ========================================================================
    top = "btop";
    htop = "btop";
    df = "df -h";
    free = "free -h";
    ps = "procs"; # Modern ps alternative

    # Disk usage
    ncdu = "ncdu --color dark";

    # ========================================================================
    # QUICK EDITS
    # ========================================================================
    # Config file shortcuts
    bashrc = "nvim ~/.bashrc";
    zshrc = "nvim ~/.zshrc";
    nvimrc = "nvim ~/.config/nvim/init.lua";

    # NixOS configs
    nixos-config = "nvim ~/dotfiles/nixos/configuration.nix";
    home-config = "nvim ~/dotfiles/hm/home.nix";
    dotfiles = "cd ~/dotfiles && nvim .";

    # ========================================================================
    # PACKAGE MANAGEMENT
    # ========================================================================
    # Update system
    update-system = "sudo nixos-rebuild switch --upgrade --flake ~/dotfiles";

    # ========================================================================
    # MISCELLANEOUS
    # ========================================================================
    # Safety nets
    rm = "rm -i"; # Confirm before deleting
    cp = "cp -i"; # Confirm before overwriting
    mv = "mv -i"; # Confirm before overwriting

    # Make commands verbose
    mkdir = "mkdir -pv";

    # Colorize output
    diff = "diff --color=auto";

    # Weather
    weather = "curl wttr.in";

    # Custom: Plants vs Zombies (from your config)
    pvz = "docker run --name pvzge -d -p 8080:80 gaozih/pvzge:latest";
  };

  home.packages = with pkgs; [
    # Modern CLI tools (for aliases)
    eza # Better ls
    bat # Better cat
    ripgrep # Better grep (rg)
    fd # Better find
    dust # Better du
    procs # Better ps
    btop # Better top

    # Development tools
    zoxide # Better cd (z command)
    fzf # Fuzzy finder
    direnv # Per-directory environments

    # Optional: Shell enhancements
    starship # Modern prompt
    atuin # Better shell history
  ];

  # ==========================================================================
  # ZSH ALIASES (if using Zsh)
  # ==========================================================================
  # Zsh users can uncomment this to share aliases
  # programs.zsh.shellAliases = programs.bash.shellAliases;
}
# ============================================================================
# ALIAS CUSTOMIZATION TIPS
# ============================================================================
# 1. Keep aliases short and memorable
# 2. Group related aliases together
# 3. Document complex aliases with comments
# 4. Consider creating shell functions for complex operations
# 5. Use meaningful prefixes (g for git, n for npm, etc.)
#
# To add personal aliases without modifying this file:
# - Create ~/.bash_aliases or ~/.zsh_aliases
# - Source it in your shell config
# ============================================================================

