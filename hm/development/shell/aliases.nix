{pkgs, ...}: {
  programs.bash.shellAliases = {
    ll = "eza -l --icons";
    la = "eza -la --icons";
    lt = "eza --tree --icons";
    ls = "eza --icons";

    cat = "bat";
    less = "bat --paging=always";
    grep = "rg";
    find = "fd";
    du = "dust";

    g = "git";
    gs = "git status";
    gss = "git status -s";
    ga = "git add";
    gaa = "git add --all";
    gap = "git add --patch";
    gc = "git commit -v";
    gca = "git commit -v -a";
    gcm = "git commit -m";
    gcam = "git commit -a -m";
    gcan = "git commit --amend --no-edit";
    gco = "git checkout";
    gcb = "git checkout -b";
    gb = "git branch";
    gba = "git branch -a";
    gbd = "git branch -d";
    gd = "git diff";
    gdc = "git diff --cached";
    gdw = "git diff --word-diff";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gpl = "git pull";
    gplr = "git pull --rebase";
    gl = "git log --oneline --graph --decorate";
    gla = "git log --oneline --graph --decorate --all";
    glp = "git log --patch";
    gst = "git stash";
    gsta = "git stash apply";
    gstl = "git stash list";
    gstp = "git stash pop";
    gstd = "git stash drop";
    gf = "git fetch";
    gfa = "git fetch --all";
    grb = "git rebase";
    grbi = "git rebase -i";
    gclean = "git clean -fd";
    greset = "git reset --hard HEAD";

    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
    rebuild-test = "sudo nixos-rebuild test --flake ~/dotfiles";
    rebuild-boot = "sudo nixos-rebuild boot --flake ~/dotfiles";
    hm = "home-manager switch --flake ~/dotfiles";
    hm-test = "home-manager build --flake ~/dotfiles";
    update-flakes = "nix flake update ~/dotfiles";
    update-all = "cd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake .";
    nix-clean = "nix-collect-garbage -d";
    nix-clean-all = "sudo nix-collect-garbage -d";
    nix-optimize = "nix-store --optimize";
    nix-search = "nix search nixpkgs";

    n = "nvim";
    v = "nvim";
    vim = "nvim";

    serve = "python -m http.server 8000";
    serve-php = "php -S localhost:8000";
    myip = "curl ifconfig.me";
    localip = "ip addr show | grep 'inet ' | grep -v 127.0.0.1";
    ports = "netstat -tulanp";

    mvn-clean = "mvn clean";
    mvn-install = "mvn clean install";
    mvn-test = "mvn clean test";
    mvn-package = "mvn clean package";
    mvn-run = "mvn spring-boot:run";
    mvn-skip-tests = "mvn clean install -DskipTests";
    gw = "./gradlew";
    gradle-build = "gradle build";
    gradle-run = "gradle bootRun";
    gradle-test = "gradle test";
    gradle-clean = "gradle clean";

    py = "python3";
    python = "python3";
    pip = "python3 -m pip";
    venv-create = "python3 -m venv venv";
    venv = "source venv/bin/activate";
    activate = "source venv/bin/activate";
    deactivate-venv = "deactivate";
    pip-install = "pip install -r requirements.txt";
    pip-freeze = "pip freeze > requirements.txt";
    pip-upgrade = "pip install --upgrade pip";
    poetry-install = "poetry install";
    poetry-shell = "poetry shell";
    poetry-run = "poetry run python";

    ni = "npm install";
    nid = "npm install --save-dev";
    nis = "npm install --save";
    ns = "npm start";
    nt = "npm test";
    nr = "npm run";
    nb = "npm run build";
    nw = "npm run watch";
    yi = "yarn install";
    ya = "yarn add";
    yad = "yarn add --dev";
    ys = "yarn start";
    yt = "yarn test";
    yr = "yarn run";
    yb = "yarn build";
    pn = "pnpm";
    pni = "pnpm install";
    pna = "pnpm add";
    pns = "pnpm start";
    pnt = "pnpm test";
    pnr = "pnpm run";

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

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";

    top = "btop";
    htop = "btop";
    df = "df -h";
    free = "free -h";
    ps = "procs";
    ncdu = "ncdu --color dark";

    bashrc = "nvim ~/.bashrc";
    zshrc = "nvim ~/.zshrc";
    nvimrc = "nvim ~/.config/nvim/init.lua";
    nixos-config = "nvim ~/dotfiles/nixos/configuration.nix";
    home-config = "nvim ~/dotfiles/hm/home.nix";
    dotfiles = "cd ~/dotfiles && nvim .";

    update-system = "sudo nixos-rebuild switch --upgrade --flake ~/dotfiles";

    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    mkdir = "mkdir -pv";
    diff = "diff --color=auto";

    weather = "curl wttr.in";
    pvz = "docker run --name pvzge -d -p 8080:80 gaozih/pvzge:latest";
  };
}
