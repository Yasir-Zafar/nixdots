# Using this repo

A practical guide to `~/dots`: how it is put together, how to change things, how to keep the machine updated and clean with `nx`, and how to get out of trouble. For *why* things are the way they are, see [PREFERENCES.md](PREFERENCES.md); for what every installed app is for, see [APPS.md](APPS.md).

- [1. How it fits together](#1-how-it-fits-together)
- [2. Where things go](#2-where-things-go)
- [3. Install / reinstall](#3-install--reinstall)
- [4. The everyday loop](#4-the-everyday-loop)
- [5. nx reference](#5-nx-reference)
- [6. Common tasks](#6-common-tasks)
- [7. What runs on its own](#7-what-runs-on-its-own)
- [8. When something goes wrong](#8-when-something-goes-wrong)
- [9. Desktop and shell cheat sheet](#9-desktop-and-shell-cheat-sheet)

---

## 1. How it fits together

There are **two flakes** that never depend on each other:

| Flake | Builds | Activated with | Lock file |
|---|---|---|---|
| `nix/` | the system: `nixosConfigurations.mntbnd` | `nx os` (runs as root) | `nix/flake.lock` |
| `hm/` | your user environment: `homeConfigurations.boi` | `nx home` (runs as you) | `hm/flake.lock` |

Each flake folder holds only `flake.nix` and `flake.lock`. Everything they build comes from the shared tree next to them (`hosts/`, `home/`, `modules/`, `pkgs/`, `lib/`). Because the locks are separate, updating home inputs (nixvim, stylix, nixcord…) can't move the system's nixpkgs, and a broken home config never blocks a system rebuild.

`nx update` updates both locks together, so in practice they pin the same nixpkgs. `nx doctor` warns if they ever drift apart.

**Shared values** (user name, host name, git identity, mail address, the assets folder) are defined once in [`lib/default.nix`](../lib/default.nix). Both flakes import it and hand it to every module as `my`, so a module writes `my.user` instead of `"boi"`.

**Every folder has a `default.nix` that only imports its siblings.** To turn something off, comment out its import line. Nothing is deleted: old setups (gnome, other greeters, emacs, scripts) stay in the tree, switched off by a commented import, so they can come back as they were.

## 2. Where things go

```text
dots/
├── nix/flake.nix          system flake (also exposes the dev-shell templates)
├── hm/flake.nix           home flake
├── hosts/mntbnd/          this machine: hardware-configuration.nix, stateVersion
├── home/boi.nix           this user: username, home dir, stateVersion
├── modules/nixos/         system modules (boot, hardware, desktop, services, gaming, …)
├── modules/home/          home modules (desktop, terminal, development, applications, nixvim)
├── pkgs/nx/               the nx command: nx.sh (plain bash) + completions
├── lib/default.nix        shared values (`my`)
├── templates/             per-project dev shells (rust, python, node, c)
├── assets/                wallpaper, avatar, GTK + icon themes (applied with nwg-look)
├── docs/                  this guide, APPS.md (what every app is for), PREFERENCES.md
└── statix.toml            lint ignores
```

| I want to… | Put it in |
|---|---|
| install a GUI app or CLI tool for me | the matching file in `modules/home/applications/` or `modules/home/terminal/tools.nix` |
| install something every user / root needs, or a system service | `modules/nixos/<area>/` |
| configure an app that has a home-manager module (`programs.<x>`) | `modules/home/…`, next to related apps |
| change a niri key bind, window rule, output | `modules/home/desktop/niri-config.nix` |
| change session-wide env vars (Wayland, Qt, SDL…) | `modules/nixos/desktop/niri.nix` |
| change default apps (what opens what) | `modules/home/applications/preferred-apps.nix` |
| change a kernel param | **test first**, see [§6](#test-a-kernel-parameter), then `modules/nixos/boot/systemd-boot.nix` |
| change the user, host or an e-mail | `lib/default.nix` only |
| change hardware-specific things | `hosts/mntbnd/` (generated file) or `modules/nixos/hardware/` |
| add a script | a `writeShellApplication` in a module (preferred) or `pkgs/` if it is bigger |

## 3. Install / reinstall

```sh
# 1. clone to ~/dots (nx expects that path; NX_DOTS overrides it)
git clone https://github.com/Yasir-Zafar/nixdots ~/dots
cd ~/dots

# 2. on a reinstall or new disk: regenerate the hardware config
nixos-generate-config --show-hardware-config > hosts/mntbnd/hardware-configuration.nix

# 3. first build of the system, then the home
sudo nixos-rebuild switch --flake ./nix#mntbnd
nix run home-manager -- switch --flake ./hm#boi

# 4. log out and back in (session vars, NH_OS_FLAKE / NH_HOME_FLAKE), then:
nx doctor
```

After the first switch, use `nx` for everything. Manual leftovers after a reinstall:

- **GTK theme / icons:** copy `assets/Gruvbox-Green-Dark-Medium` to `~/.themes/` and `assets/Gruvbox-Plus-Dark` to `~/.icons/`, then pick them in `nwg-look`. The theme isn't maintained in nixpkgs, which is why it lives in the repo.
- **Proton mail bridge:** one-time login, see the comment at the top of `modules/home/applications/communication.nix`.
- **Thunderbird theme:** the "Gruvbox Dark Thunderbird" add-on, installed by hand.
- **Flatpaks:** nothing to do. The ones declared in `modules/nixos/desktop/flatpak.nix` (Sober) install themselves on the first switch (the first time takes a while: it downloads the runtimes).
- **Zen:** the extensions declared in `modules/home/applications/zen.nix` install themselves on first start. The profile itself (tabs, logins, history, workspaces) is not in the repo: restore `~/.config/zen` from a backup or sync if you want it back.

## 4. The everyday loop

```sh
# 1. edit something
nvim ~/dots/modules/home/applications/media.nix

# 2. new file? the flakes only see files git knows about
git add -N path/to/new-file.nix

# 3. check it builds, without activating anything
nx build                  # or just one side: nx os build / nx home build

# 4. apply
nx home                   # home changes: safe, instant, roll back with nx rollback home
nx os test                # system changes: live now, but NOT the boot default
nx os                     # happy with it: same as `nx os switch`, becomes the boot default

# 5. commit
git commit -am "…"
```

`nx os test` versus `nx os switch`:

| | activates now | becomes the default boot entry | after a reboot |
|---|---|---|---|
| `nx os test` | yes | no | you are back on the previous generation |
| `nx os` / `nx os switch` | yes | yes | you stay on the new one |
| `nx os boot` | no | yes | the new one starts |

Use `test` for anything that touches services, the desktop session or networking. Use `boot` for things that only matter at boot (kernel, initrd, greeter).

## 5. nx reference

`nx` lives in [`pkgs/nx/`](../pkgs/nx/): plain bash in `nx.sh`, wrapped by `writeShellApplication`, which runs shellcheck at build time. It always passes `~/dots/nix` and `~/dots/hm` explicitly, so it works even when `NH_OS_FLAKE` isn't set in the current shell. Tab completion works in fish and zsh, including flake input names for `nx update`. `NX_DOTS=/other/path nx …` points it at another checkout.

### `nx update [input…]`

Updates the lock files of **both** flakes.

```sh
nx update                 # every input in nix/ and hm/
nx update nixpkgs         # just nixpkgs, in both
nx update nixvim stylix   # inputs that only exist in hm/: nix/ prints "skipped" and moves on
```

Updating only rewrites `flake.lock`. Nothing changes until you build and switch. To undo an update, `git checkout nix/flake.lock hm/flake.lock`.

### `nx os [switch|boot|test|build]`

Rebuilds the system through `nh`, which shows a build tree and a package diff, then asks for sudo. The default mode is `switch`; see the table in [§4](#4-the-everyday-loop) for the others. `build` writes its result link to `~/.cache/nx/os`, not the repo. Extra args go to `nh`, e.g. `nx os switch --show-trace`.

### `nx home [switch|build] [-b]`

Rebuilds the home environment. `-b` moves files that would be overwritten (a hand-made config, or one an app wrote) to `<name>.bak` instead of failing. `nx doctor` lists leftover `.bak` files so you can clean them up. `build` writes to `~/.cache/nx/home`.

### `nx all`

`update`, then `os switch`, then `home switch`, stopping at the first failure. This is the weekly "update everything" command. If you'd rather be careful, run the steps by hand and use `nx os test` before `nx os`.

### `nx build`

Builds both system and home without activating anything. Use it as a quick "does my change even build" check, and before committing. Result links go to `~/.cache/nx/{os,home}`; they also keep the last build safe from garbage collection.

### `nx clean [nh args]` and `nx optimise`

- `nx clean`: `nh clean all --keep-since 7d --keep 5`. It removes old system, home and user-profile generations and direnv gc roots, then garbage-collects the store. Pass your own args to override, e.g. `nx clean --keep 2`.
- `nx optimise`: hard-links identical files in the store. It already runs weekly on its own (see [§7](#7-what-runs-on-its-own)), so you rarely need it.

Old generations are your rollback points; `--keep 5` keeps five. For "remove everything old", see `nx storage clean --hard`.

### `nx diff`

Shows the package changes between the system you **booted** and the one that is **current** (`nvd`). Useful after a few `switch`es to see what changed since the last reboot.

### `nx status`

A one-screen overview: when each lock last changed, which nixpkgs revision each flake pins, uncommitted changes in the repo, and free disk space.

### `nx doctor`

Checks for the usual problems and prints `ok` or `WARN` for each:

| Check | What a WARN means / what to do |
|---|---|
| `NH_OS_FLAKE` / `NH_HOME_FLAKE` set | the session predates the home config; log out and in (nx itself doesn't care) |
| stub flake in `~/.config/home-manager` | a bare `nh home switch` would build that instead; delete it |
| booted kernel matches current | you switched to a new kernel/initrd; reboot when convenient |
| failed system / user units | `systemctl --failed`, `systemctl --user --failed`, then `journalctl -u <unit>` |
| stray `core.*` files | old crash dumps in `~` or the repo; delete them |
| `*.bak` files | leftovers from `nx home -b`; compare with the managed file and delete |
| both flakes pin the same nixpkgs | run `nx update` |
| repo is clean | uncommitted changes; commit or stash |

### `nx rollback [os|home] [N]`

```sh
nx rollback               # list the latest system and home generations
nx rollback os            # back to the previous system generation
nx rollback os 120        # back to system generation 120
nx rollback home          # back to the previous home generation
nx rollback home 61       # back to home generation 61
```

A system rollback activates the old generation **and** makes it the boot default. If the system doesn't even boot, pick an older generation in the boot menu instead (see [§8](#8-when-something-goes-wrong)).

### `nx try <greeter>`

Boot-tests another login screen: `tuigreet`, `lightdm`, `gdm`, `ly`, or `sysc` (the current one).

1. Swaps the greeter import line in `modules/nixos/desktop/default.nix`.
2. Builds; nothing is activated yet.
3. Asks before making it the **default boot entry** (`nh os boot`).
4. Always puts the file back, whatever happened.

Reboot to see it. To go back, run `nx os boot` and reboot, or pick the previous generation in the boot menu. To switch greeters for good, edit that import line yourself (see [§6](#switch-the-greeter-for-good)).

### `nx firmware [check|update|devices|history|bios]`

Firmware updates from LVFS through `fwupd`. `check` (the default) refreshes metadata and lists available updates. `update` installs them, which usually means a reboot into the updater. `bios` prints vendor, model and BIOS version. Plug in the charger before `update`.

### `nx storage [report|clean] [flags]`

`report` (the default) is read-only. It shows:

- **safe to delete:** caches programs rebuild on their own (uv, pip, JetBrains, appimage-run, mesa shader cache, thumbnails), each with its size
- **also cleaned by `clean`:** journal size, docker dangling images/stopped containers, unused flatpak runtimes
- **big, but yours:** Steam libraries, Prism, Pictures, Projects, flatpak and `/nix/store`. These are never touched.

`clean` deletes the safe items after asking. It also vacuums the journal to 200M, prunes docker (stopped containers, dangling images) and removes unused flatpak runtimes.

| Flag | Also removes | Cost |
|---|---|---|
| `-y` | (nothing; skips the question) | |
| `--browsers` | Zen / Chromium / Firefox caches. **Skipped automatically while a browser is running.** | sites load slower for a while |
| `--steam-shaders` | Steam's shader cache | brief stutter in games while shaders recompile |
| `--trash` | everything in the trash | gone for good |
| `--hard` | all three above, **plus** `~/.cache/nix` (every flake input is downloaded again on the next build), **every docker image no container uses**, and **all old generations** (`nh clean all --keep 1`) | no rollback left until you build again |

Two tiers in practice:

- **Soft**, any time: `nx storage clean`, plus `nx clean` now and then.
- **Hard**, when disk is really tight and the system is known-good: `nx storage clean --hard`. Afterwards the boot menu is refreshed (`switch-to-configuration boot` on the *current* system, with nothing rebuilt), so deleted generations disappear from it.

### `nx lint` / `nx fmt`

- `nx lint`: `statix` (anti-patterns) and `deadnix` (unused code) over the repo. Skips `hosts/mntbnd/hardware-configuration.nix`, and statix also skips what `statix.toml` lists.
- `nx fmt`: `alejandra` over every folder with nix files.

CI runs the same checks on every push, plus an **eval** job that evaluates both flakes. That catches removed packages and renamed options that lint can't see. A red `eval` usually means "something upstream was renamed": read the error, fix the option, push.

## 6. Common tasks

### Add a program

1. Find it: `nix search nixpkgs <name>` or [search.nixos.org](https://search.nixos.org/packages). To just try it without installing: `, <command>` (comma).
2. If home-manager has a `programs.<name>` module, prefer it: it also writes the config. Otherwise add it to `home.packages` in the right file under `modules/home/`.
3. `nx home`.

### Remove or pause a program

Comment out its line with a short note saying why, e.g. `# nodemon # node --watch does this natively`, then `nx home` / `nx os`. Keep the line; the repo documents what was tried.

### Add a module

```sh
$EDITOR modules/home/applications/foo.nix   # { pkgs, ... }: { home.packages = [ pkgs.foo ]; }
# add ./foo.nix to modules/home/applications/default.nix
git add -N modules/home/applications/foo.nix
nx home build && nx home
```

Need the user name, email or assets in a module? Add `my` to its arguments (`{ pkgs, my, ... }:`) and use `my.user`, `my.mail`, `my.assets + "/file.png"`. Use `+ "/file"`, never `"${my.assets}/file"`: the latter copies the whole assets folder, icon theme included, into the store.

### Add a flake input

1. Add it to `nix/flake.nix` or `hm/flake.nix` (or both). Use `inputs.nixpkgs.follows = "nixpkgs"` unless the project says that breaks its binary cache, like niri and noctalia.
2. Lock just that input: `nix flake lock` in that folder. This adds new inputs without moving the others.
3. Import its module in the flake's `modules = [ … ]` list, then use it.

### Start a new project with its own toolchain

```sh
mkdir ~/Projects/thing && cd ~/Projects/thing
nix flake init -t ~/dots/nix#rust     # or: python, node, c
direnv allow                          # the shell loads whenever you cd in
```

- **rust:** cargo, clippy, rust-analyzer, bacon, openssl wired up.
- **python:** a `uv`-managed `.venv` on nix's python; `uv add requests` to install.
- **node:** nodejs, pnpm, typescript.
- **c:** a clang stdenv (CC/CXX = clang inside the shell), cmake, meson, ninja, lldb.

Edit the project's `flake.nix` to add more. Its `flake.lock` pins that project independently of the system.

### Switch the greeter for good

In `modules/nixos/desktop/default.nix`, change the `./greeters/sysc-greet.nix` line to another file in `greeters/`, then `nx os boot` and reboot. What all greeters share is in `greeters/common.nix`. If you switch away from sysc-greet, update the `nx try` mapping in `pkgs/nx/nx.sh`, because it looks for that line.

### Test a kernel parameter

Never put an untested parameter in the config.

1. Reboot. In the boot menu, select the newest entry and press `e`.
2. Add or remove the parameter on the line, then press Enter to boot once with it.
3. Check what it affects: sound and mic, keyboard and touchpad, brightness, suspend. `cat /proc/cmdline` confirms it took.
4. Fine? Edit `kernelParams` in `modules/nixos/boot/systemd-boot.nix`, `nx os boot`, reboot.
5. Not fine? Just reboot; the edit was for that one boot only.

The comments in that file say what each current parameter does and which ones are worth re-testing.

### Add a flatpak

Add its app ID (from [flathub.org](https://flathub.org)) to `services.flatpak.packages` in `modules/nixos/desktop/flatpak.nix`, then `nx os`. It installs in the background during activation. Flatpaks you install by hand are left alone, and all of them update weekly.

### Add a Zen extension

Install it in Zen as usual, then put its ID in `ExtensionSettings` in `modules/home/applications/zen.nix` so a reinstall brings it back. The ID is in `about:support` → Extensions, or:

```sh
jq -r '.addons[] | select(.location=="app-profile") | "\(.id)  \(.defaultLocale.name)"' ~/.config/zen/*/extensions.json
```

### Change the theme

- **Terminal, shell and CLI colours:** Stylix, `modules/home/desktop/stylix.nix`. Only the targets listed there are themed.
- **GTK theme and icons:** `nwg-look`, from the folders in `assets/`.
- **niri colours:** `modules/home/desktop/niri-config.nix`. Focus ring and border are intentionally off.
- **Prompt:** `modules/home/terminal/prompt.nix` (starship).

## 7. What runs on its own

| What | When | Where it's set |
|---|---|---|
| garbage collection: generations older than 7 days, keeping at least 5 | weekly | `modules/nixos/nix.nix` (`programs.nh.clean`) |
| store dedupe (`nix store optimise`) | weekly | `modules/nixos/nix.nix` |
| emergency gc of dead store paths if a build leaves < 5 GiB free (frees to 20 GiB) | during builds | `modules/nixos/nix.nix` (`min-free` / `max-free`) |
| journal capped at 500 MB | always | `modules/nixos/nix.nix` |
| docker: stopped containers, dangling images, unused networks older than a week | weekly | `modules/nixos/development/default.nix` |
| thumbnails not used for 30 days | daily | `modules/home/applications/utilities.nix` |
| `flatpak update` | weekly | `modules/nixos/desktop/flatpak.nix` |
| SSD trim | weekly | `modules/nixos/hardware/default.nix` |
| tldr pages refresh | on use | `modules/home/terminal/tools.nix` |

Firmware is **not** updated automatically; run `nx firmware`.

## 8. When something goes wrong

| Symptom | Do this |
|---|---|
| A build fails with "file not found" / "does not exist" for a file you just made | `git add -N <file>`: flakes only see files git tracks |
| `nx home` fails with "would be clobbered" | `nx home -b`, then compare the `.bak` with the new file |
| Eval error after `nx update` (option renamed, package removed) | read the error, fix that option; or `git checkout nix/flake.lock hm/flake.lock` to go back to the old pins |
| Something broke after `nx os test` | reboot: you're back on the previous generation |
| Something broke after `nx os` / `nx os switch` | `nx rollback os` |
| The desktop doesn't come up / greeter broken | at the boot menu, choose the previous generation; once in, `nx rollback os` or fix and `nx os` |
| Home looks wrong (prompt, colours, apps) | `nx rollback home` |
| Laptop hot, fans loud, stutter on battery | the power profile was probably set to *performance* by hand (`Mod+B`); a manual pick overrides the automatic battery profile. Cycle back to *balanced*. `tuned-adm active` shows the current one |
| Disk full | `nx storage` to see why; `nx storage clean`; `nx clean`; `--hard` as a last resort |
| A service keeps failing | `nx doctor`, then `journalctl -b -u <unit>` (system) or `journalctl --user -u <unit>` |
| A missing command | type it anyway: command-not-found suggests the package; `, <cmd>` runs it once |

The boot menu keeps the last 10 system generations (`configurationLimit`), so an older working one is always one reboot away.

## 9. Desktop and shell cheat sheet

### niri (Mod = Super)

| Keys | Action |
|---|---|
| `Mod+Return` / `Mod+Shift+Return` | Ghostty / Ghostty with nvim |
| `Mod+W` / `Mod+E` | Zen / Nautilus |
| `Mod+Space` (or `Mod+P`) / `Mod+;` | launcher / emoji picker |
| `Mod+V` / `Mod+A` | clipboard history / control center |
| `Mod+Tab` / `Alt+Tab` | overview / window switcher |
| `Mod+Escape` / `Mod+Shift+Escape` | session menu / lock screen |
| `Mod+B` | cycle power profile (balanced → performance → power-saver) |
| `Mod+I` / `Mod+Shift+N` | caffeine on/off (no sleep) / do-not-disturb on/off |
| `Mod+Shift+B` | hide/show bar |
| `Mod+Shift+/` | show all binds (niri's overlay, with titles) |
| `Ctrl+Shift+Escape` | Mission Center |
| `Mod+H J K L` (or arrows) | focus left / down / up / right |
| `Mod+Shift+H J K L` | move column/window |
| `Mod+Home` / `Mod+End` (+`Shift` to move) | first / last column |
| `Mod+1…5` / `Mod+Shift+1…5` | go to / move to workspace |
| `Mod+Ctrl+H/L` (or arrows) / `+Shift` | focus the other monitor / move the column there |
| `Mod+[` / `Mod+]` (+`Shift` to move) | workspace down / up |
| `Mod+R` / `Mod+Shift+R` | cycle column width / window height presets |
| `Mod+-` / `Mod+=` (+`Shift` for height) | width −10% / +10% |
| `Mod+F` / `Mod+Shift+F` / `Mod+C` | maximize column / fullscreen / center |
| `Mod+,` / `Mod+.` | pull window into column / push it out |
| `Mod+T` / `Mod+Shift+T` | float / tabbed column |
| `Mod+Q` | close window |
| `Print` / `Shift+Print` / `Ctrl+Print` | screenshot: interactive / screen / window |
| volume, mic, brightness, media keys | work everywhere, including the lock screen |
| `Mod+Shift+S` | select an area and annotate it in satty |
| `Mod+Shift+P` / `Mod+Shift+E` | monitors off / quit niri |
| `Mod`+scroll | move between columns / workspaces |

### Shell (fish in Ghostty; zsh is the login shell)

| Type | Get |
|---|---|
| `du`, `df`, `grep`, `find`, `cat`, `ps`, `top`, `rm`… | expands on screen to dust, duf, rg, fd, bat, procs, btop, `rm -i`… (fish abbreviations; scripts still get the real commands). `abbr` lists them all |
| `l`, `ll`, `la`, `lt` | eza listings |
| `g…` (`gs`, `gd`, `gl`, `gp`…), `lg` | git shortcuts, lazygit |
| `cd <part of a path>` | zoxide jumps to the best match |
| `Ctrl+R` | atuin history search |
| `Ctrl+Alt+F` / `Ctrl+Alt+L` / `Ctrl+Alt+S` | fzf.fish: find files / git log / git status (`Ctrl+Alt+P` processes, `Ctrl+V` variables) |
| `y` | yazi file manager; you end up where you quit |
| `spf` | superfile |
| `, <cmd>` | run any package once without installing it |
| `extract <archive>` / `compress <files> <out.tar.zst>` | ouch |
| `mkcd <dir>`, `backup <file>`, `mkvenv` | small helpers |
| `tldr <cmd>` | example-first help |

Git: delta is the pager for diff/log/show/blame, `git difftool` opens difftastic, and pulls rebase. The git aliases are in `modules/home/development/tools/git.nix` (`git lg`, `git s`, `git pf`…).

Games: put `mangohud %command%` in a game's Steam launch options for the FPS/frametime overlay. `gamemoderun %command%` for gamemode.
