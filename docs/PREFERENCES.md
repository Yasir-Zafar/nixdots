# Preferences

How this config is meant to be kept, and what not to "fix". Read this before changing the repo, whether you're me, a collaborator or an AI assistant. For how to use the repo, see [USAGE.md](USAGE.md).

## Principles

- **Documented config.** The repo is a record, not only a build recipe. Old or unused setups stay in the tree, switched off by a commented import, with a note on why: the gnome desktop and its dconf settings, the alternate greeters, emacs, the old scripts, retroarch, easyeffects. **Moving and reorganising is fine; deleting is not.** When an app is replaced, comment out the old line with the reason instead of removing it.
- **Two separate flakes.** `nix/` (system) and `hm/` (home) keep their own lock files and build independently. Don't merge them. Shared values go in `lib/default.nix`.
- **One machine.** This is a single x86_64 laptop (`mntbnd`). No multi-host or multi-arch abstractions.
- **Declare it in Nix.** Scripts and timers are written in Nix (`writeShellApplication`, systemd units, tmpfiles rules) rather than kept as loose files. Grow `nx` only when that is clearly better than a declared unit.
- **Check upstream before changing fast-moving areas.** For home-manager unstable options, Noctalia (v5) and niri, read the current docs first; options get renamed.

## Never change without asking

- **No disk encryption, Secure Boot or boot hardening.** No LUKS, no lanzaboote, and `systemd-boot.editor` stays on. It's also how kernel params get tested.
- **Passwordless sudo for wheel** stays.
- **Firewall ports** stay as they are.
- **Millennium** (Steam) stays commented out in `modules/nixos/gaming/steam.nix`. Upstream lags behind Steam versions.
- **Swap and `vm.swappiness = 10`** stay. Modded Minecraft falls over the moment it loses focus otherwise.
- **The GTK theme and icons in `assets/`** stay, applied with nwg-look. That theme isn't maintained in nixpkgs.
- **Kernel parameters** change only after a one-boot test from the boot menu (see USAGE §6).

## Working style

- **Phases.** Bigger changes happen in steps. After each step: build, report, and wait for an explicit "continue".
- **Build, don't switch.** Assistants build (`nx build`, `nh … build -o ~/.cache/nx/…`); I switch. Nothing lands as a `result` link in the repo.
- **Be extra careful with anything that boots:** bootloader, kernel, initrd, greeter, session. Prefer `nx os test`, keep the previous generation as the way back, and verify where possible that boot artefacts are unchanged.
- **Ask before heavy or networked nix commands** that aren't a normal build (e.g. `nix flake archive`).
- **Commit messages and commits are mine** unless I ask.

## Look and feel

- **Gruvbox dark medium everywhere.** Stylix handles CLI/terminal targets (opt-in per target), nwg-look the GTK theme, and the rest is set per app.
- **niri:** no gaps, no focus ring, **no window border** (don't add one, not even 1px), no shadows, square corners. Vim keys plus arrows. Noctalia for the bar, launcher and session menu.
- **Terminal:** Ghostty running fish (zsh is the login shell, bash is kept configured). Emacs-style line editing. A single-line pure-style prompt (starship). Fastfetch on a fresh Ghostty window.
- **Fonts:** JetBrainsMono Nerd Font (mono), Inter (UI), Source Serif (serif).
- **Editors:** nixvim (kickstart-style, nightly) day to day, plus VS Code, Cursor and Antigravity, and PyCharm/CLion.

## Apps: kept on purpose

These were reviewed, and the current choice is deliberate:

| Kept | Instead of | Why / note |
|---|---|---|
| Discord + Vencord (nixcord) | Vesktop | works; switching means logging in again. nixcord can switch with `vesktop.enable` |
| VS Code, Cursor, Antigravity | one editor | all in use |
| Postman | Bruno | in use |
| GNOME Feeds | Newsflash | low-activity but still maintained |
| superfile **and** yazi | one file manager | both available: `spf`, `y` |
| media-libs, all fonts, tree, ncdu | pruning | low value, risk of breaking something |
| Python libs in the system python | only per-project | templates exist for new projects; the global one stays |
| global `CC=clang`, `PKG_CONFIG_PATH` | devshell only | still relied on; templates are the way forward |

## Not wanted

- gpu-screen-recorder
- a niri focus ring or border
- removing documented-but-unused modules
- merging the flakes, or generalising for other hosts or architectures
- storage, boot or security hardening (LUKS, Secure Boot, password for sudo)
