//! nx storage: what uses space and what is safe to delete; `clean` deletes only
//! regenerable caches (plus journal vacuum, docker and flatpak prune).

use crate::sh::{self, cmd, du, home, on_path, output, succeeds};
use crate::ui;
use anyhow::Result;
use clap::ValueEnum;
use std::path::PathBuf;

#[derive(clap::Args)]
pub struct Args {
    #[arg(value_enum, default_value_t = Action::Report)]
    pub action: Action,
    /// skip the question
    #[arg(short, long)]
    pub yes: bool,
    /// also browser caches (zen, chromium)
    #[arg(long)]
    pub browsers: bool,
    /// also steam shader caches (games recompile them, brief stutter)
    #[arg(long)]
    pub steam_shaders: bool,
    /// also empty the trash
    #[arg(long)]
    pub trash: bool,
    /// all of the above, plus ~/.cache/nix, every unused docker image, and all old generations
    #[arg(long)]
    pub hard: bool,
}

impl Args {
    /// The plain report (what the TUI shows).
    pub fn report() -> Args {
        Args {
            action: Action::Report,
            yes: false,
            browsers: false,
            steam_shaders: false,
            trash: false,
            hard: false,
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq, ValueEnum)]
pub enum Action {
    Report,
    Clean,
}

pub struct Report {
    pub disk: String,
    /// regenerable caches with their size
    pub caches: Vec<(PathBuf, u64)>,
    pub journal: String,
    pub docker: bool,
    pub flatpak_unused: Option<usize>,
    /// big folders that are yours (never touched), plus /nix/store
    pub yours: Vec<(PathBuf, u64)>,
    /// set when browser caches were asked for but a browser is running
    pub browser_running: bool,
}

/// The caches `clean` deletes for these flags.
fn cache_paths(a: &Args) -> (Vec<PathBuf>, bool) {
    let home = home();
    let cache = home.join(".cache");
    let share = home.join(".local/share");
    // ~/.cache/nix (flake + tarball fetcher cache) is only in --hard: wiping it makes the
    // next rebuild download every input again
    let mut paths: Vec<PathBuf> = [
        "uv",
        "JetBrains",
        "appimage-run",
        "mesa_shader_cache",
        "thumbnails",
        "pip",
    ]
    .iter()
    .map(|d| cache.join(d))
    .collect();
    if a.hard {
        paths.push(cache.join("nix"));
    }
    let mut browser_running = false;
    if a.browsers || a.hard {
        // wiping a running browser's cache can corrupt its state
        browser_running = succeeds(cmd("pgrep").arg("^\\.?(zen|firefox|chromium)"));
        if !browser_running {
            paths.extend(["zen", "chromium", "mozilla"].iter().map(|d| cache.join(d)));
        }
    }
    if a.steam_shaders || a.hard {
        paths.push(share.join("Steam/steamapps/shadercache"));
    }
    if a.trash || a.hard {
        paths.extend([share.join("Trash/files"), share.join("Trash/info")]);
    }
    (
        paths.into_iter().filter(|p| p.is_dir()).collect(),
        browser_running,
    )
}

pub fn collect(a: &Args) -> Report {
    let home = home();
    let share = home.join(".local/share");
    let (paths, browser_running) = cache_paths(a);
    let journal = output(cmd("journalctl").arg("--disk-usage"));
    let journal = journal
        .split_whitespace()
        .find(|w| w.ends_with('M') || w.ends_with('G'))
        .unwrap_or("?")
        .to_string();
    let yours = [
        share.join("Steam/steamapps/common"),
        share.join("Steam/steamapps/compatdata"),
        share.join("PrismLauncher"),
        home.join("Pictures"),
        home.join("Projects"),
        home.join("Games"),
        PathBuf::from("/var/lib/flatpak"),
        PathBuf::from("/nix/store"),
    ];
    Report {
        disk: output(cmd("df").args(["-h", "/"]))
            .lines()
            .nth(1)
            .unwrap_or_default()
            .to_string(),
        caches: paths
            .into_iter()
            .map(|p| {
                let s = du(&p);
                (p, s)
            })
            .collect(),
        journal,
        docker: on_path("docker") && succeeds(cmd("docker").arg("info")),
        flatpak_unused: on_path("flatpak").then(|| {
            output(cmd("flatpak").args(["list", "--unused"]))
                .lines()
                .skip(1)
                .count()
        }),
        yours: yours
            .into_iter()
            .filter(|p| p.is_dir())
            .map(|p| {
                let s = du(&p);
                (p, s)
            })
            .collect(),
        browser_running,
    }
}

fn size_line(path: &std::path::Path, bytes: u64, extra: &str) {
    println!(
        "  {}{:>10}{}  {}{extra}",
        ui::size_colour(bytes),
        ui::human(bytes),
        ui::reset(),
        path.display()
    );
}

pub fn run(a: &Args) -> Result<()> {
    let r = collect(a);
    if r.browser_running {
        ui::caution("a browser is running, skipping browser caches (close it and rerun)");
    }
    ui::step("Disk");
    println!("  {}", r.disk);

    ui::heading("Safe to delete (regenerable caches)");
    for (p, s) in &r.caches {
        size_line(p, *s, "");
    }
    let total: u64 = r.caches.iter().map(|(_, s)| s).sum();
    println!(
        "  {}{:>10}{}  total",
        ui::bold(),
        ui::human(total),
        ui::reset()
    );

    ui::heading("Also cleaned by 'clean' (not counted above)");
    ui::note(&format!("journal:  {} -> vacuum to 200M", r.journal));
    if r.docker {
        ui::note(
            "docker:   prune stopped containers + dangling images (tagged images are kept; see 'docker system df')",
        );
    }
    if let Some(n) = r.flatpak_unused {
        ui::note(&format!("flatpak:  {n} unused runtime(s)"));
    }
    if a.hard {
        ui::note(
            "docker:   --hard also removes every image no container uses (docker system prune -a)",
        );
        ui::note(
            "nix:      --hard keeps only the current generation, gc's the store, refreshes the boot menu",
        );
    } else {
        ui::note(
            "nix:      use 'nx clean' (old generations + store gc, needs sudo), or --hard here",
        );
    }

    ui::heading("Big, but yours (never touched)");
    for (p, s) in &r.yours {
        let extra = if p.as_os_str() == "/nix/store" {
            "  (nx apps shows what in it is yours)"
        } else {
            ""
        };
        size_line(p, *s, extra);
    }

    if a.action != Action::Clean {
        println!();
        ui::note("run 'nx storage clean' to delete the safe items above");
        return Ok(());
    }
    println!();
    if !a.yes
        && !sh::confirm("Delete the caches above, vacuum the journal, prune docker and flatpak?")
    {
        println!("aborted");
        return Ok(());
    }
    ui::step("Cleaning");
    let used = || {
        output(cmd("df").args(["--output=used", "-B1", "/"]))
            .lines()
            .nth(1)
            .and_then(|l| l.trim().parse::<u64>().ok())
            .unwrap_or(0)
    };
    let before = used();
    for (p, _) in &r.caches {
        // empty the folder, keep the folder itself
        if let Ok(entries) = std::fs::read_dir(p) {
            for e in entries.flatten() {
                let path = e.path();
                let _ = if e.file_type().is_ok_and(|t| t.is_dir()) {
                    std::fs::remove_dir_all(&path)
                } else {
                    std::fs::remove_file(&path)
                };
            }
        }
    }
    sh::run(
        cmd("sudo")
            .args(["journalctl", "--vacuum-size=200M"])
            .stdout(std::process::Stdio::null()),
    )?;
    if r.docker {
        let mut c = cmd("docker");
        c.args(["system", "prune", "-f"]);
        if a.hard {
            c.arg("-a");
        }
        sh::succeeds(&mut c);
    }
    if r.flatpak_unused.is_some() {
        sh::succeeds(cmd("flatpak").args(["uninstall", "--unused", "--noninteractive"]));
    }
    if a.hard {
        sh::run_or_exit(cmd("nh").args(["clean", "all", "--keep", "1"]))?;
        // drop the deleted generations from the boot menu without rebuilding anything
        sh::run_or_exit(
            cmd("sudo").args(["/run/current-system/bin/switch-to-configuration", "boot"]),
        )?;
    }
    println!();
    ui::step(&format!(
        "Freed about {}",
        ui::human(before.saturating_sub(used()))
    ));
    Ok(())
}
