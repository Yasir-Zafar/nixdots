# Apps and what they're for

Everything this config installs or runs, grouped by purpose: what each thing is, why it's here, and which file brings it in. Paths are relative to the repo root. "(sys)" means a system package or service (`modules/nixos`), "(home)" means home-manager (`modules/home`).

For how to add or remove things, see [USAGE.md](USAGE.md#6-common-tasks). For choices that were kept on purpose, see [PREFERENCES.md](PREFERENCES.md#apps-kept-on-purpose).

- [Desktop session](#desktop-session)
- [Everyday apps](#everyday-apps)
- [Communication](#communication)
- [Media](#media)
- [Creative](#creative)
- [Documents and notes](#documents-and-notes)
- [Network and downloads](#network-and-downloads)
- [Files and system utilities](#files-and-system-utilities)
- [Terminal](#terminal)
- [Shells](#shells)
- [CLI tools](#cli-tools)
- [Nix tooling](#nix-tooling)
- [Development](#development)
- [Gaming](#gaming)
- [Graphics stack](#graphics-stack)
- [Audio](#audio)
- [Background services](#background-services)
- [Fonts and theming](#fonts-and-theming)
- [Installed but switched off](#installed-but-switched-off)

---

## Desktop session

| App | What it is | Why it's here | From |
|---|---|---|---|
| **niri** | Scrolling tiling Wayland compositor: windows sit in columns on an endless horizontal strip | The window manager. Config (binds, rules, outputs, animations) is written in Nix through niri-flake | `desktop/niri.nix` (sys), `desktop/niri-config.nix` (home) |
| **Noctalia** | Desktop shell: bar, launcher, notifications, control center, session menu, lock screen, wallpaper, power-profile switcher | Everything around the windows. `Mod+Space` launcher, `Mod+V` clipboard, `Mod+A` control center, `Mod+Escape` session menu, `Mod+Shift+Escape` lock, `Mod+B` power profile | `desktop/noctalia.nix` (home); system side in `desktop/niri.nix` |
| **sysc-greet** | Login screen on greetd, running on niri itself | The greeter: Gruvbox theme, ASCII-rain background. Alternatives are kept in `desktop/greeters/` | `desktop/greeters/sysc-greet.nix` (sys) |
| **xwayland-satellite** | Runs X11 apps under niri | Steam, some games and older apps still need X11 | `desktop/niri.nix` (sys) |
| **xdg-desktop-portal-gnome / -gtk** | Bridges between sandboxed/Wayland apps and the desktop | Screen sharing and recording (gnome portal), file pickers, opening links | `desktop/niri.nix` (sys) |
| **polkit-gnome** | Password prompt when an app needs admin rights | GUI apps asking for root (disks, some settings). niri-flake's own agent is disabled so only one runs | `desktop/niri.nix` (sys) |
| **gnome-keyring** | Stores secrets (passwords, tokens) unlocked at login | Proton bridge credentials, browser/app passwords | `desktop/greeters/common.nix` (sys) |
| **AccountsService** | Holds the user avatar for greeters | Shows `assets/profile.jpg` on the login screen | `desktop/greeters/common.nix` (sys) |
| **Bibata Modern Classic** | Cursor theme | Set through stylix, 24px | `desktop/stylix.nix`, `desktop/default.nix` (home) |
| **nwg-look** | GTK settings editor | Applies the Gruvbox GTK theme and icons from `assets/` (not packaged in nixpkgs) | `desktop/default.nix` (home) |

### Wayland helpers (sys, `desktop/niri.nix`)

| Tool | Use |
|---|---|
| **wl-clipboard** | `wl-copy` / `wl-paste`: clipboard from the terminal; nvim uses it for `"+` |
| **cliphist** | Clipboard history store (used by Noctalia's clipboard panel) |
| **grim** + **slurp** | Screenshot tools: grim captures, slurp selects an area. Used by the `Mod+Shift+S` bind |
| **satty** | Screenshot annotation: arrows, text, blur, crop. `Mod+Shift+S` |
| **brightnessctl** | Screen brightness (the brightness keys) |
| **playerctl** | Media keys: play/pause/next for any player |
| **libnotify** | `notify-send` for scripts (fish `done` plugin uses it) |
| **xdg-utils** | `xdg-open`: opens files/links with the default app |
| **wlr-randr** | Output info/config for wlroots-style protocols (niri also has `niri msg outputs`) |
| **jq** | JSON on the command line (scripts, `nx`, `niri msg --json`) |
| **libdisplay-info** | Library for reading monitor EDID data (used by display tools) |

## Everyday apps

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Zen** (beta) | Firefox-based browser with vertical tabs and a clean UI | Main browser, `Mod+W`, default for links. Installed through the flake's home-manager module: policies (no updater, no telemetry) and the extensions below are declared; the profile itself is left alone | `applications/zen.nix` (home), flake input `zen-browser` |
| **Ghostty** | GPU-accelerated terminal | Main terminal, `Mod+Return`. Runs fish, gets Stylix colours | `terminal/ghostty.nix` (home) |
| **Nautilus** | GNOME file manager | `Mod+E`; default for folders. Thumbnails, network shares (gvfs), "Open in terminal" (Ghostty) | `applications/utilities.nix` (home), extension in `desktop/greeters/common.nix` |
| **Loupe** | GNOME image viewer | Default for images | `applications/utilities.nix` (home) |
| **GNOME Text Editor** | Simple GUI text editor | Default for plain text and markdown files opened from the file manager | `applications/documents.nix` (home) |
| **GNOME Calculator / Calendar / Disks** | Calculator, calendar, disk partitioning/SMART/format tool | Small everyday utilities | `desktop/greeters/common.nix` (sys) |
| **File Roller** | Archive manager (GUI) | Default for zip/tar/7z; extract from Nautilus | `desktop/greeters/common.nix` (sys) |
| **Mission Center** | Task manager (CPU, GPU, RAM, disk, processes) | `Ctrl+Shift+Escape` | `applications/utilities.nix` (home) |

### Zen extensions (declared in `applications/zen.nix`)

| Extension | What it does |
|---|---|
| **uBlock Origin** | Ad and tracker blocker |
| **Bitwarden** | Password manager |
| **SponsorBlock** | Skips sponsor segments in YouTube videos |
| **Return YouTube Dislike** | Shows dislike counts again |
| **I still don't care about cookies** | Dismisses cookie banners |
| **Zen Internet** | Per-site themes that blend websites into Zen |
| **Unpaywall** | Finds free legal copies of paywalled papers |
| **Google Scholar Button** | Looks up the paper you're reading on Scholar |
| **Indie Wiki Buddy** | Redirects from Fandom to independent wikis |

## Communication

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Discord** + **Vencord** + **OpenASAR** | Discord, with a client mod (plugins, themes) and a faster startup shim | Chat. Plugins and the Gruvbox quick-CSS are declared in Nix via nixcord | `applications/nixcord.nix` (home) |
| **Beeper** | One app for many chat networks (WhatsApp, Telegram, Signal, …) | Everything that isn't Discord, in one place | `applications/communication.nix` (home) |
| **Thunderbird** | Mail client | Proton mail through the local bridge. Settings are declared; the account lives in the Thunderbird profile (its address is a secret, see USAGE "Secrets"); also the `mailto:` handler | `applications/communication.nix` (home) |
| **Proton Mail Bridge** | Local IMAP/SMTP server for an encrypted Proton account | Lets Thunderbird read Proton mail; runs as a user service | `applications/communication.nix` (home) |

## Media

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Showtime** | GNOME's modern video player | Default for video files (simple, good-looking) | `applications/media.nix` (home) |
| **mpv** | Minimal, very configurable video/audio player | Default for audio files; the "power" player. High-quality scaling + interpolation on AC; a lighter `battery` profile is applied automatically when unplugged, and `big-video` for > 1440p | `applications/media.nix` (home) |
| **Amberol** | Small music player for local files | Playing a folder of music without a library manager | `applications/media.nix` (home) |
| **Pear Desktop** | Desktop client for YouTube Music | Streaming music | `applications/media.nix` (home) |
| **GNOME Podcasts** | Podcast client | Subscribing to and playing podcasts | `applications/media.nix` (home) |
| **OBS Studio** | Recording and streaming studio | Screen recording/streaming (captures through the portal) | `applications/media.nix` (home) |
| **ffmpeg** | Command-line audio/video converter | Converting/cutting media; used by many other tools (yt-dlp, thumbnailers) | `applications/media.nix` (home) |

## Creative

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Pinta** | Simple raster image editor (Paint.NET-like) | Quick image edits; GIMP/Krita are kept commented | `applications/creative.nix` (home) |
| **Pixelorama** | Pixel-art editor with animation | Sprites and pixel art | `applications/creative.nix` (home) |
| **Blender** | 3D modelling, animation, rendering, video editing | 3D work | `applications/creative.nix` (home) |
| **Godot** | Game engine | Game development | `applications/creative.nix` (home) |
| **Video Trimmer** | Cuts a part out of a video without re-encoding | Quick clip trimming | `applications/creative.nix` (home) |
| **Switcheroo** | Image format converter (GUI) | png ↔ jpg ↔ webp etc. | `applications/creative.nix` (home) |
| **Curtail** | Image compressor (GUI) | Shrinking images before sending/uploading | `applications/creative.nix` (home) |
| **Impression** | Writes ISO images to USB drives | Making bootable sticks | `applications/utilities.nix` (home) |

## Documents and notes

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Papers** | GNOME's PDF/document viewer (successor of Evince) | Default PDF viewer | `applications/documents.nix` (home) |
| **Foliate** | E-book reader (epub, mobi…) | Reading books | `applications/documents.nix` (home) |
| **Obsidian** | Markdown notes with links between notes | Notes / knowledge base | `applications/documents.nix` (home) |
| **LibreOffice** | Office suite | Word/Excel/PowerPoint files | `applications/documents.nix` (home) |
| **Errands** | To-do list app | Tasks | `applications/documents.nix` (home) |
| **Frog** | OCR: grab text from images/screenshots | Copying text out of pictures | `applications/documents.nix` (home) |
| **Decoder** | QR code scanner and generator | Wi-Fi codes, links | `applications/documents.nix` (home) |
| **qpdf** | Command-line PDF tool (merge, split, decrypt, repair) | PDF fixing and scripting | `applications/documents.nix` (home) |
| **GNOME Feeds** | RSS/Atom reader | Following blogs/news | `applications/utilities.nix` (home) |

## Network and downloads

| App | What it is | Why it's here | From |
|---|---|---|---|
| **yt-dlp** | Command-line video/audio downloader (YouTube and ~1000 sites) | Downloading media | `applications/network.nix` (home) |
| **Parabolic** | GUI for yt-dlp | Same, with a window | `applications/network.nix` (home) |
| **aria2** | Fast multi-connection downloader (http, torrent, metalink) | Big downloads from the terminal | `applications/network.nix` (home) |
| **Fragments** | BitTorrent client (GNOME) | Torrents | `applications/network.nix` (home) |
| **Nicotine+** | Soulseek client | Finding/sharing music | `applications/network.nix` (home) |
| **Proton VPN** | VPN client | VPN | `applications/network.nix` (home) |
| **Syncthing** | Peer-to-peer folder sync between devices | Syncing folders with other devices, no cloud. Web UI at `localhost:8384` | `services/syncthing.nix` (sys) |
| **wget**, **curl** | HTTP downloaders | Everyday downloading/scripting | `services/networking.nix` (sys) |
| **nmap** | Network scanner | Finding devices/open ports on a network | `services/networking.nix` (sys) |
| **inetutils** | Classic tools: `ping`, `telnet`, `ftp`, `hostname`… | Basic network debugging | `services/networking.nix` (sys) |

## Files and system utilities

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Warehouse** | Flatpak manager (GUI) | Managing flatpaks (Sober and others) | `applications/utilities.nix` (home) |
| **Gear Lever** | AppImage manager: integrates AppImages into the launcher, updates them | Apps only shipped as AppImage | `applications/utilities.nix` (home) |
| **ffmpegthumbnailer**, **gnome-epub-thumbnailer**, **libheif** | Thumbnail generators for videos, e-books, HEIC photos | Previews in Nautilus | `applications/utilities.nix` (home), `desktop/greeters/common.nix` (sys) |
| **powertop** | Power-consumption analyser | Finding what drains the battery | `applications/utilities.nix` (home) |
| **TheClicker** | Auto-clicker | Repetitive clicking (games) | `applications/utilities.nix` (home) |
| **btop** | Terminal resource monitor | `top` abbreviation; quick look at CPU/RAM/processes | `applications/utilities.nix` (home) |
| **pavucontrol** | PulseAudio/PipeWire volume mixer | Per-app volume, picking input/output devices, profiles | `services/audio.nix` (sys) |
| **bluez**, **bluez-tools** | Bluetooth stack and CLI tools (`bluetoothctl`, `bt-device`) | Bluetooth; Noctalia uses it for its Bluetooth panel | `services/bluetooth.nix` (sys) |
| **intel-gpu-tools** | `intel_gpu_top` and friends | Watching GPU load (video decode, games) | `hardware/intel-graphics.nix` (sys) |
| **vulkan-tools**, **mesa-demos**, **libva-utils**, **vdpauinfo** | `vulkaninfo`, `glxinfo`, `vainfo`, `vdpauinfo` | Checking that GPU acceleration works | `hardware/intel-graphics.nix` (sys) |
| **fwupd** | Firmware updates from LVFS | BIOS/SSD/peripheral firmware; `nx firmware` | `hardware/default.nix` (sys) |
| **git**, **vim** | Version control, fallback editor | Always available, also for root | `users/packages.nix` (sys) |

## Terminal

| App | What it is | Why it's here | From |
|---|---|---|---|
| **zellij** | Terminal multiplexer (tabs, splits, sessions) | Started by hand with `zellij` when a session should survive or needs splits | `terminal/workflow.nix` (home) |
| **atuin** | Shell history in a database, with fuzzy search | `Ctrl+R` in every shell (up-arrow is left alone) | `terminal/workflow.nix` (home) |
| **lazygit** | Terminal UI for git | `lg`; staging hunks, rebasing, browsing history | `terminal/workflow.nix`, `development/tools/git.nix` (home) |
| **yazi** | Fast terminal file manager with previews (images in Ghostty, PDFs, video) | `y`; quits into the directory you were in | `terminal/workflow.nix` (home) |
| **superfile** | Another terminal file manager (multi-panel) | `spf` | `terminal/workflow.nix` (home) |
| **starship** | Prompt for all shells | Pure-style single-line prompt: path, branch, dirty `*`, ❄ in nix shells, ❯ red on error | `terminal/prompt.nix` (home) |
| **fastfetch** | System info printer | Shown once when a new Ghostty window opens | `terminal/fetch.nix` (home) |

## Shells

| Shell | Role | From |
|---|---|---|
| **fish** | Interactive shell in Ghostty. Abbreviations instead of command-shadowing aliases, plugins: **fzf.fish** (Ctrl+Alt+F/L/S pickers), **autopair** (closes brackets/quotes), **done** (notifies when a command > 10 s finishes in the background), **sponge** (drops failed commands from history) | `terminal/shell/fish.nix` |
| **zsh** | Login shell (and VS Code terminals). Plugins: zsh-completions, **fzf-tab** (completion menu through fzf), history-substring-search, fast-syntax-highlighting, autosuggestions. Cached `compinit` for fast startup | `terminal/shell/zsh.nix`, `users/default.nix` |
| **bash** | Kept configured for scripts and fallback (vi mode, history settings) | `terminal/shell/bash.nix` |

Shared aliases live in `terminal/shell/aliases/` and are applied to all three.

## CLI tools

All home, from `terminal/tools.nix` unless noted.

| Tool | Replaces / does | Typical use |
|---|---|---|
| **eza** | `ls` with icons, git status, tree view | `l`, `ll`, `la`, `lt` |
| **bat** | `cat`/`less` with syntax highlighting | `cat file` expands to `bat …` |
| **ripgrep** (`rg`) | very fast `grep` | `grep` expands to `rg` |
| **fd** | fast, friendly `find` | `find` expands to `fd` |
| **fzf** | fuzzy finder for anything piped into it | `ff`, `fv`, and the shell pickers |
| **zoxide** | `cd` that learns your frequent directories | `cd dots` jumps to `~/dots` from anywhere |
| **direnv** + **nix-direnv** | loads a project's dev shell when you `cd` in | projects made from `templates/` |
| **procs** | modern `ps` | `ps` expands to `procs` |
| **dust** | disk usage tree (`du`) | `du` expands to `dust` |
| **duf** | disk free overview (`df`) | `df` expands to `duf` |
| **ncdu** | interactive disk-usage browser | finding what fills a folder |
| **tree** | directory tree | quick structure dumps |
| **ouch** | one tool for every archive format | `extract x.zip`, `compress a b out.tar.zst` |
| **unzip**, **p7zip**, **unrar** | single-format archivers | formats/scripts that need them directly |
| **glow** | renders markdown in the terminal | `md README.md` |
| **tealdeer** (`tldr`) | short, example-first man pages | `tldr tar` |
| **just** | command runner (`justfile`) | project task shortcuts |
| **claude-code** | Claude Code CLI, from [claude-code-nix](https://github.com/sadjow/claude-code-nix) (rebuilt hourly from Anthropic's releases; its own auto-updater is off) | AI coding assistant in the terminal. Settings and memory stay in `~/.claude/` |
| **difftastic** | syntax-aware diff | `git difftool` |
| **delta** | pretty pager for git diffs | automatic for `git diff/log/show/blame` |
| **gh** | GitHub CLI | PRs, issues, cloning (`development/tools/git.nix`) |

## Nix tooling

| Tool | What it does | From |
|---|---|---|
| **nx** | This repo's one command for updates, rebuilds, cleanup, rollback, firmware… ([USAGE §5](USAGE.md#5-nx-reference)) | `pkgs/nx/` |
| **nh** | Nicer `nixos-rebuild` / `home-manager` with build trees and diffs; also the weekly gc | `nix.nix` (sys), `terminal/tools.nix` (home) |
| **nix-output-monitor** (`nom`) | Readable build progress | `terminal/tools.nix` |
| **nvd** | Package diff between two generations (`nx diff`) | `terminal/tools.nix` |
| **nix-tree** | Browse what a package/generation depends on and why | `terminal/tools.nix` |
| **comma** (`,`) + **nix-index** | Run any package once without installing it; "command not found" suggests the package | `terminal/tools.nix`, input `nix-index-database` |
| **statix**, **deadnix**, **alejandra** | Nix linter, unused-code finder, formatter (`nx lint`, `nx fmt`) | `development/nix.nix` (sys) |
| **nil** | Nix language server (nvim) | `development/nix.nix` (sys) |
| **sops-nix** + **sops** + **age** | Encrypted secrets in the repo (`secrets/secrets.yaml`), decrypted at login by a user service; `sops` edits them, `age` makes keys. Holds git's email and the Proton address | `modules/home/secrets.nix` |
| **nix-ld** | Lets downloaded, non-Nix binaries find their libraries | `services/compat.nix` (sys) |
| **appimage-run** (binfmt) | Run AppImages directly | `services/compat.nix` (sys) |
| **Flatpak** + **nix-flatpak** | Second app source, sandboxed. nix-flatpak makes the list declarative (Sober is declared) and updates weekly | `desktop/greeters/common.nix`, `desktop/flatpak.nix` (sys) |

## Development

### Editors

| Editor | Use | From |
|---|---|---|
| **Neovim** (nixvim, nightly) | Main editor, kickstart-style. LSPs: rust-analyzer, clangd, basedpyright, ts_ls, nil, lua_ls, bashls, jsonls. Plus telescope, treesitter, cmp, gitsigns, conform (formatting), lint, neo-tree, which-key, trouble, todo-comments, mini, autopairs, indent-blankline | `modules/home/nixvim/` |
| **VS Code** | General GUI editor | `development/editors/vscode.nix` |
| **Cursor** | VS Code fork with built-in AI | `development/editors/vscode.nix` |
| **Antigravity** | Google's AI IDE (VS Code-based) + CLI | `hm/flake.nix` (input `antigravity-nix`) |
| **PyCharm**, **CLion** | JetBrains IDEs for Python and C/C++ | `development/editors/jetbrains.nix` |

### Languages and tooling

| Area | Tools | Notes | From |
|---|---|---|---|
| **C / C++** | gcc, clang, clang-tools (clangd, clang-format), lldb, cmake, meson, ninja, make, pkg-config, ispc (SIMD compiler) | compilers installed globally, but `CC` isn't forced any more; projects that want clang use `templates/c` | `development/c.nix` (sys) |
| **Python** | plain python3, no global libraries | quick scripts, `py`, `serve`, `mkvenv`; libraries per project with `templates/python` (uv) | `development/py.nix` (sys) |
| **Rust** | rustup, cargo-edit (`cargo upgrade`), bacon (watch/check loop), cargo-audit (vulnerabilities), cargo-outdated, taplo (TOML) | native deps (openssl…) come from the project shell: `templates/rust` | `development/languages/rust.nix` |
| **JavaScript / TS** | nodejs, typescript, eslint, prettier, npm-check-updates, ngrok (expose localhost), Postman (API client) | global npm prefix `~/.npm-global` | `development/languages/javascript.nix` |
| **Java** | Temurin JDK 21 | `JAVA_HOME` set by `programs.java` | `development/languages/java.nix` |
| **Writing / config linting** | markdownlint-cli2, vale (prose linter), hadolint (Dockerfiles) | | `development/languages/plugins.nix` |
| **Git extras** | git-lfs (large files), git-filter-repo (history rewriting), git-crypt (encrypted files in repos), git-absorb (auto-fixup commits) | | `development/tools/git.nix` |
| **Docker** | Container runtime, weekly auto-prune | the `pvz` alias runs a container | `development/default.nix` (sys) |

### Dev shell templates

`nix flake init -t ~/dots/nix#<name>`: **rust**, **python** (uv), **node** (pnpm), **c** (clang stdenv). See [USAGE §6](USAGE.md#start-a-new-project-with-its-own-toolchain).

## Gaming

| App | What it is | Why it's here | From |
|---|---|---|---|
| **Steam** | Game store/launcher, with Proton for Windows games | Main game library. Remote Play and dedicated-server ports open; also installs a "Steam (gamescope)" session | `gaming/steam.nix` (sys) |
| **Proton-GE** | Community Proton build with extra fixes/codecs | Pick it per game in Steam when stock Proton fails | `gaming/steam.nix` (sys) |
| **Heroic** | Launcher for Epic, GOG and Amazon games | Non-Steam stores | `gaming/default.nix` (sys) |
| **Prism Launcher** | Minecraft launcher with instance/mod management | Modded Minecraft | `gaming/default.nix` (sys) |
| **Lunar Client** | Minecraft client for PvP servers | Vanilla PvP | `gaming/default.nix` (sys) |
| **Dolphin** | GameCube / Wii emulator | Emulation | `gaming/default.nix` (sys) |
| **Wine** (WoW64) + **winetricks** | Run Windows programs; winetricks installs their dependencies | Windows apps/games outside Steam | `users/packages.nix`, `gaming/default.nix` (sys) |
| **gamemode** | Raises a game's priority while it runs | `gamemoderun %command%` in Steam launch options | `gaming/performance.nix` (sys) |
| **MangoHud** | In-game overlay: FPS, frametimes, CPU/GPU load, temps | `mangohud %command%` in Steam launch options | `gaming/default.nix` (sys) |
| **Sober** (flatpak) | Roblox client for Linux | Roblox | `desktop/flatpak.nix` (sys, nix-flatpak) |
| **ntsync** | Kernel module for Windows-style sync primitives | Wine 10+/Proton use `/dev/ntsync` when present: faster than esync/fsync | `gaming/performance.nix` (sys) |
| **SteamOS sysctls** | `split_lock_mitigate=0`, `sched_cfs_bandwidth_slice_us=3000`, `tcp_fin_timeout=5` | Same values SteamOS ships: no penalty for games that hit split locks, smoother pacing | `gaming/performance.nix` (sys) |
| **GNOME games** | Mahjongg, Chess, 2048, Mines, Sudoku, Aisleriot (solitaire) | Quick casual games | `gaming/default.nix` (sys) |

## Graphics stack

All in `hardware/intel-graphics.nix` (sys); the laptop has Intel Arc (Arrow Lake) integrated graphics on the i915 driver.

| Package | Role |
|---|---|
| **intel-media-driver** | VA-API video decode/encode (iHD): smooth, low-power video in browsers and players |
| **libvdpau-va-gl** | VDPAU on top of VA-API, for the few apps that only speak VDPAU |
| **vpl-gpu-rt** | Intel Quick Sync (oneVPL): hardware encoding in ffmpeg/OBS (`*_qsv` encoders) |
| **intel-compute-runtime** | OpenCL / Level Zero: GPU compute for apps that use it |
| **vulkan-loader**, **vulkan-validation-layers**, **vulkan-extension-layer** | Vulkan runtime pieces and debugging layers |
| 32-bit graphics | enabled for Steam/Proton (`hardware.graphics.enable32Bit`) |
| **early KMS** | `i915` loads in the initrd, so the screen keeps one mode from boot to greeter (no flicker) |

## Audio

| Component | Role | From |
|---|---|---|
| **PipeWire** (+ ALSA, PulseAudio and 32-bit compat) | The sound server: every app's audio, screen-share audio, Bluetooth audio | `services/audio.nix` (sys) |
| **WirePlumber** | PipeWire's session manager. Configured for Bluetooth: high-quality codecs (LDAC, aptX HD, AAC, SBC-XQ…), A2DP + headset roles, hardware volume | `services/audio.nix` (sys) |
| **rtkit** | Real-time priority for audio threads (no crackling) | `services/audio.nix` (sys) |
| **GStreamer** (+ base/good/bad/ugly/libav plugins) | Media framework GNOME apps use to play audio/video (Showtime, Amberol, Podcasts, thumbnails) | `desktop/media-libs.nix` (sys) |

## Background services

| Service | What it does | From |
|---|---|---|
| **NetworkManager** + **systemd-resolved** | Wi-Fi/Ethernet; DNS with DNS-over-TLS when available, DNSSEC, mDNS | `services/networking.nix` |
| **firewall** | Blocks inbound connections except the listed ports | `services/networking.nix` |
| **timesyncd** | Keeps the clock right (Cloudflare + pool.ntp.org) | `services/networking.nix` |
| **tuned** (+ PPD API) | Power profiles: balanced / performance / power-saver, `balanced-battery` automatically on battery | `services/power.nix` |
| **upower** | Battery information (Noctalia, notifications) | `services/power.nix` |
| **earlyoom** | Kills the biggest process before RAM runs out, instead of the whole desktop freezing | `boot/systemd-boot.nix` |
| **zram** + swapfile | Compressed swap in RAM first, then the 8 GB swapfile | `hardware/swap.nix` |
| **fstrim** | Weekly SSD trim | `hardware/default.nix` |
| **fwupd** | Firmware update daemon | `hardware/default.nix` |
| **flatpak update** | Weekly update of all flatpaks | `desktop/flatpak.nix` |
| **gvfs** | Trash, network shares, phones/cameras in Nautilus | `desktop/greeters/common.nix` |
| **sushi** | Spacebar quick-look previews in Nautilus | `desktop/greeters/common.nix` |
| **at-spi2-core** | Accessibility bus (some apps complain without it) | `desktop/greeters/common.nix` |
| **Syncthing** | Folder sync (see Network) | `services/syncthing.nix` |
| **Docker** | Container daemon | `development/default.nix` |
| **Proton Mail Bridge** | User service for mail | `applications/communication.nix` (home) |
| **systemd-coredump** | Keeps crash dumps (max 1 GB) for debugging | `boot/systemd-boot.nix` |
| **sops-nix** | Decrypts secrets into RAM at login (user service) | `modules/home/secrets.nix` |
| Automatic maintenance | gc, store optimise, journal cap, docker prune, thumbnail ageing ([USAGE §7](USAGE.md#7-what-runs-on-its-own)) | various |

## Fonts and theming

| Item | Use | From |
|---|---|---|
| **JetBrainsMono Nerd Font** | Monospace everywhere (terminal, editors); Nerd glyphs for icons | `desktop/fonts.nix` (sys), `desktop/stylix.nix` (home) |
| **Inter** | UI font (GTK/Qt) | same |
| **Source Serif Pro** | Serif default | `desktop/fonts.nix` |
| **Iosevka**, **Atkinson Mono/Hyperlegible**, **Roboto**, **Source Sans**, **Ubuntu** | Alternatives/fallbacks some apps and sites ask for | `desktop/fonts.nix` |
| **Noto** (+ CJK, colour emoji), **DejaVu**, **Liberation** | Coverage for every script and emoji; metric-compatible MS fonts for documents | `desktop/fonts.nix` |
| **Nerd Fonts Symbols**, **Font Awesome**, **Material Design Icons** | Icon fonts used by bars/prompts/apps | `desktop/fonts.nix` |
| **Stylix** (gruvbox-dark-medium) | Colours for ghostty, bat, fzf, lazygit, zellij, yazi | `desktop/stylix.nix` |
| **Gruvbox-Green-Dark-Medium** (GTK), **Gruvbox-Plus-Dark** (icons) | GTK theme and icons, from `assets/`, applied with nwg-look | `assets/` |
| Qt → GTK platform theme | Qt apps follow the GTK theme | `desktop/qt.nix` |

## Installed but switched off

Kept in the tree for reference; enable by un-commenting the import or line.

| What | Where |
|---|---|
| Full GNOME desktop (+ extensions, dconf settings) | `modules/nixos/desktop/gnome.nix`, `modules/home/desktop/gnome-settings.nix` |
| Other greeters: tuigreet, LightDM, GDM, ly | `modules/nixos/desktop/greeters/` |
| Declarative GTK theme attempt | `modules/home/desktop/gtk.nix` |
| Emacs (pgtk) + its LSP/tooling set | `modules/home/development/editors/emacs.nix` |
| SQLite tools (sqlite, sqlitebrowser) | `modules/home/development/tools/sql.nix` |
| EasyEffects (audio effects) | `modules/home/applications/easyeffect.nix` |
| RetroArch (melonDS, mGBA), Ryubing, PCSX2 | `modules/nixos/gaming/retroarch.nix` |
| Old helper scripts + battery-full notifier | `modules/home/scripts/` |
| Millennium (Steam theming) | `modules/nixos/gaming/steam.nix` (commented package line) |
| Commented single apps | GIMP, Krita (`creative.nix`), Kooha (`media.nix`), Chromium (`network.nix`), gdm-settings (`utilities.nix`), gnome-usage (`greeters/common.nix`), swappy (`niri.nix`), nodemon/nginx (`javascript.nix`), cargo-watch (`rust.nix`), WebStorm/DataGrip (`jetbrains.nix`), pure prompt (`fish.nix`) |
