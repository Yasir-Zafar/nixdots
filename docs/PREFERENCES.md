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
- **`vm.swappiness = 10` and the swapfile** stay. Modded Minecraft falls over the moment it loses focus otherwise. zram was added as a faster first swap tier (approved); swappiness was not touched.
- **The GTK theme and icons in `assets/`** stay, applied with nwg-look. That theme isn't maintained in nixpkgs.
- **Kernel parameters** change only after a one-boot test from the boot menu (see USAGE §6), or when it is proven from the kernel's own config that a parameter does nothing or is overridden. On that basis `mitigations=auto` (already the default) was removed and `loglevel=3` became `boot.consoleLogLevel` (nixos appended `loglevel=4` after it). `intel_iommu=on` is **not** a default on this kernel and stays. On 2026-10-15 I also had `acpi_osi=Linux`, the audio DSP override (`dsp_driver=1`) and the NVMe latency cap removed **without** a test boot, by choice; `systemd-boot.nix` lists each with the symptoms that mean it's needed back. `acpi_backlight=native` and `i8042.nopnp` stay.

## Working style

- **Phases.** Bigger changes happen in steps. After each step: build, report, and wait for an explicit "continue".
- **Build, don't switch.** Assistants build (`nx build`, `nh … build -o ~/.cache/nx/…`); I switch. Nothing lands as a `result` link in the repo.
- **Be extra careful with anything that boots:** bootloader, kernel, initrd, greeter, session. Prefer `nx os test`, keep the previous generation as the way back, and verify where possible that boot artefacts are unchanged.
- **Ask before heavy or networked nix commands** that aren't a normal build (e.g. `nix flake archive`).
- **Commit messages and commits are mine** unless I ask.

## Performance choices

- One OOM killer: earlyoom. systemd-oomd is off (it watched no slices here).
- Wi-Fi power saving is off (latency over a little battery).
- tuned without `dynamic_tuning`. Picking a profile by hand (`Mod+B`) overrides the automatic battery profile until you switch back to balanced.
- mpv drops to a lighter profile on battery and for > 1440p video.
- zsh uses a cached completion dump (full check daily and after each home switch).
- Gaming: `ntsync` loaded, plus the SteamOS sysctls (`split_lock_mitigate=0` and two others), done in place instead of adding nix-gaming as an input.
- Early KMS (`i915` in the initrd) for a flicker-free boot. Proven by diffing the initrd: only i915 and its dependencies were added.

## Flakes and sources

- Prefer nixpkgs (it's cached). Pull an app from a flake only when that clearly helps: fresher releases (claude-code-nix), declarative config (Zen's home-manager module, nix-flatpak), or nothing else ships it (niri-flake, Noctalia, sysc-greet, Antigravity, nixcord).
- nixos-hardware: not used. There's no OmniBook profile, and the generic modules duplicate what is already set.
- **Zen: never set `programs.zen-browser.profiles`.** The module rewrites `profiles.ini` when it's set, and the live profile (`~/.config/zen/15738ebx.Default Profile`) must stay untouched. Declare things through `policies` instead.
- Claude Code's data (`~/.claude/`, `~/.claude.json`, per-project memory) is never managed by the repo.

## Privacy and secrets

- The repo is public, so **personal values go in `secrets/secrets.yaml` (sops-nix)**, not in `.nix` files or `lib/`. Today that's git's email and the Proton address. Git commits use the GitHub **noreply** address (`<id>+Yasir-Zafar@users.noreply.github.com`), so new commits don't publish a real address; the old Gmail author email stays in past commits unless history is rewritten.
- The age key (`~/.config/sops/age/keys.txt`) never goes in the repo. It's backed up separately.
- Values a module needs *while building* can't be secrets (they'd end up in the public store and the repo). In that case the setting moves out of Nix instead: the Thunderbird account now lives only in the Thunderbird profile.
- This is about privacy, not hardening: the "no LUKS / Secure Boot / sudo password" rule below still stands.

## Key binds

- One modifier family per job: plain `Mod` for windows and apps, `Mod+Shift` to move or for the "bigger" variant, `Mod+Ctrl` for monitors.
- Noctalia features get short single keys (`Mod+Space/V/A/B/I`); rarely used or destructive ones need Shift (`Mod+Shift+E/P/N/B`).
- Every spawn bind gets a `hotkey-overlay.title`, so `Mod+Shift+/` stays readable.
- Media, volume and brightness keys work on the lock screen.

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

Reversed on 2026-10-15: the global Python libraries, `CC=clang` and `PKG_CONFIG_PATH` are gone. Python is plain `python3`, and projects get their libraries and native deps from `templates/` dev shells.

## Not wanted

- gpu-screen-recorder
- a niri focus ring or border
- removing documented-but-unused modules
- merging the flakes, or generalising for other hosts or architectures
- storage, boot or security hardening (LUKS, Secure Boot, password for sudo). Secrets via sops-nix are wanted (privacy), see above
