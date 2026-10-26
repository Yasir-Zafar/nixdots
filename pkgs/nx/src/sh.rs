//! Running other programs. nx is glue: nh, nix, nvd, fwupdmgr, git and friends do the work.

use anyhow::{Context, Result, bail};
use std::path::{Path, PathBuf};
use std::process::{Command, ExitStatus, Stdio};
use std::time::{Duration, Instant};

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

/// Updates and builds stop below this charge (percent) while running on battery.
const LOW_BATTERY: u32 = 10;

/// The charge, when it is under LOW_BATTERY and discharging (plugged in is fine).
fn low_battery() -> Option<u32> {
    std::fs::read_dir("/sys/class/power_supply")
        .ok()?
        .flatten()
        .filter(|e| e.file_name().to_string_lossy().starts_with("BAT"))
        .find_map(|e| {
            let read = |f: &str| std::fs::read_to_string(e.path().join(f)).unwrap_or_default();
            let level: u32 = read("capacity").trim().parse().ok()?;
            (read("status").trim() == "Discharging" && level < LOW_BATTERY).then_some(level)
        })
}

/// Every process as (pid, parent pid, command line with NULs between the arguments).
fn processes() -> Vec<(i32, i32, String)> {
    std::fs::read_dir("/proc")
        .into_iter()
        .flatten()
        .flatten()
        .filter_map(|e| {
            let pid = e.file_name().to_str()?.parse().ok()?;
            // "pid (name) state ppid ...": the name can hold spaces and parentheses
            let stat = std::fs::read_to_string(e.path().join("stat")).ok()?;
            let ppid = stat[stat.rfind(')')? + 1..]
                .split_whitespace()
                .nth(1)?
                .parse()
                .ok()?;
            let args = std::fs::read(e.path().join("cmdline")).unwrap_or_default();
            Some((pid, ppid, String::from_utf8_lossy(&args).into_owned()))
        })
        .collect()
}

/// System or home activation is running. Stopping that half-way can leave a half-switched
/// system, so it is never interrupted.
fn activating(procs: &[(i32, i32, String)]) -> bool {
    procs.iter().any(|(_, _, args)| {
        args.split('\0').any(|a| {
            let name = Path::new(a).file_name();
            name.is_some_and(|n| n == "switch-to-configuration")
                || (name.is_some_and(|n| n == "activate") && a.contains("home-manager-generation"))
        })
    })
}

/// The process and everything started below it (nh, nix, nom, ...).
fn family(procs: &[(i32, i32, String)], pid: i32) -> Vec<i32> {
    let mut pids = vec![pid];
    let mut i = 0;
    while let Some(&parent) = pids.get(i) {
        i += 1;
        pids.extend(procs.iter().filter(|p| p.1 == parent).map(|p| p.0));
    }
    pids
}

fn signal(pids: &[i32], sig: i32) {
    for &pid in pids {
        // SAFETY: plain kill(2) on pids we just listed
        unsafe {
            libc::kill(pid, sig);
        }
    }
}

/// `status()` for updates and builds: refuses to start below LOW_BATTERY and stops what is
/// running (like Ctrl+C) when the battery gets there, unless activation has begun. Both are
/// errors, so chains like `nx all` stop too.
fn guarded_status(c: &mut Command) -> Result<ExitStatus> {
    let name = c.get_program().to_string_lossy().into_owned();
    if let Some(level) = low_battery() {
        bail!("battery at {level}%, not starting {name}");
    }
    let mut child = c
        .spawn()
        .with_context(|| format!("could not start {name}"))?;
    let pid = child.id() as i32;
    // the charge and the time when the interrupt was sent
    let mut stopped: Option<(u32, Instant)> = None;
    loop {
        std::thread::sleep(Duration::from_millis(500));
        if let Some(status) = child.try_wait()? {
            return match stopped {
                Some((level, _)) => bail!("battery at {level}%, {name} stopped"),
                None => Ok(status),
            };
        }
        match stopped {
            None => {
                if let Some(level) = low_battery() {
                    let procs = processes();
                    if !activating(&procs) {
                        signal(&family(&procs, pid), libc::SIGINT);
                        stopped = Some((level, Instant::now()));
                    }
                }
            }
            // it ignored the interrupt
            Some((_, at)) if at.elapsed() > Duration::from_secs(15) => {
                signal(&family(&processes(), pid), libc::SIGKILL);
            }
            _ => {}
        }
    }
}

/// Like `run`, with the battery guard.
pub fn run_guarded(c: &mut Command) -> Result<bool> {
    Ok(guarded_status(c)?.success())
}

/// Like `run_or_exit`, with the battery guard.
pub fn run_guarded_or_exit(c: &mut Command) -> Result<()> {
    let status = guarded_status(c)?;
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
