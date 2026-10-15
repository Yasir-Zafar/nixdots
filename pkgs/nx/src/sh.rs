//! Running other programs. nx is glue: nh, nix, nvd, fwupdmgr, git and friends do the work.

use anyhow::{Context, Result};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

/// Where everything lives. NX_DOTS points nx at another checkout.
#[derive(Clone)]
pub struct Paths {
    pub dots: PathBuf,
    pub os: PathBuf,
    pub hm: PathBuf,
    /// where the greeter import lives (nx try)
    pub desktop: PathBuf,
    /// `nh … build` result links; they also keep the last build from being garbage-collected
    pub links: PathBuf,
}

impl Paths {
    pub fn new() -> Self {
        let home = home();
        let dots = std::env::var_os("NX_DOTS")
            .map(PathBuf::from)
            .unwrap_or_else(|| home.join("dots"));
        let cache = std::env::var_os("XDG_CACHE_HOME")
            .map(PathBuf::from)
            .unwrap_or_else(|| home.join(".cache"));
        let links = cache.join("nx");
        let _ = std::fs::create_dir_all(&links);
        Paths {
            os: dots.join("nix"),
            hm: dots.join("hm"),
            desktop: dots.join("modules/nixos/desktop"),
            links,
            dots,
        }
    }

    /// every directory with nix files (for fmt; assets/ has none)
    pub fn nix_dirs(&self) -> Vec<PathBuf> {
        ["nix", "hm", "hosts", "modules", "home", "pkgs", "lib"]
            .iter()
            .map(|d| self.dots.join(d))
            .collect()
    }
}

pub fn home() -> PathBuf {
    std::env::var_os("HOME")
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("/"))
}

pub fn cmd(program: &str) -> Command {
    Command::new(program)
}

/// Run with the terminal attached; Ok(true) when it exited 0.
pub fn run(c: &mut Command) -> Result<bool> {
    let name = c.get_program().to_string_lossy().into_owned();
    let status = c
        .status()
        .with_context(|| format!("could not start {name}"))?;
    Ok(status.success())
}

/// Run with the terminal attached and stop nx with the same exit code if it fails,
/// like `set -e` did in the bash version.
pub fn run_or_exit(c: &mut Command) -> Result<()> {
    let name = c.get_program().to_string_lossy().into_owned();
    let status = c
        .status()
        .with_context(|| format!("could not start {name}"))?;
    if !status.success() {
        std::process::exit(status.code().unwrap_or(1));
    }
    Ok(())
}

/// Captured stdout (stderr is dropped); empty when the program is missing or fails.
pub fn output(c: &mut Command) -> String {
    c.stdin(Stdio::null())
        .stderr(Stdio::null())
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).into_owned())
        .unwrap_or_default()
}

/// Captured stdout; on failure the error carries the program's stderr. Nothing reaches
/// the terminal directly, which matters under the TUI: stray output there would draw
/// over its screen.
pub fn output_checked(c: &mut Command) -> Result<String> {
    let name = c.get_program().to_string_lossy().into_owned();
    let o = c
        .stdin(Stdio::null())
        .output()
        .with_context(|| format!("could not start {name}"))?;
    if !o.status.success() {
        let err = String::from_utf8_lossy(&o.stderr);
        let tail: Vec<&str> = err.lines().rev().take(5).collect();
        let tail: Vec<&str> = tail.into_iter().rev().collect();
        anyhow::bail!("{name} failed: {}", tail.join("\n"));
    }
    Ok(String::from_utf8_lossy(&o.stdout).into_owned())
}

/// Quiet success check (for `docker info` and similar probes).
pub fn succeeds(c: &mut Command) -> bool {
    c.stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map(|s| s.success())
        .unwrap_or(false)
}

pub fn on_path(program: &str) -> bool {
    std::env::var_os("PATH")
        .map(|p| std::env::split_paths(&p).any(|d| d.join(program).is_file()))
        .unwrap_or(false)
}

/// `du -sb`: apparent size of a tree in bytes (0 when unreadable).
pub fn du(path: &Path) -> u64 {
    output(cmd("du").arg("-sb").arg(path))
        .split_whitespace()
        .next()
        .and_then(|n| n.parse().ok())
        .unwrap_or(0)
}

/// Ask a yes/no question on the terminal; anything but "y" is no.
pub fn confirm(question: &str) -> bool {
    use std::io::Write;
    print!("{question} [y/N] ");
    let _ = std::io::stdout().flush();
    let mut answer = String::new();
    let _ = std::io::stdin().read_line(&mut answer);
    answer.trim() == "y"
}
