//! nx rollback: list generations, or go back to one.

use crate::sh::{self, cmd, output};
use crate::ui;
use anyhow::{Context, Result, bail};
use clap::ValueEnum;

#[derive(Clone, Copy, ValueEnum)]
pub enum Target {
    Os,
    Home,
}

pub struct Generation {
    pub id: String,
    pub date: String,
    pub current: bool,
    /// home-manager only: the generation's store path (its `activate` script)
    pub path: Option<String>,
}

/// NixOS generations, newest first.
pub fn system() -> Vec<Generation> {
    let current = std::fs::read_link("/nix/var/nix/profiles/system").ok();
    let mut gens: Vec<(std::time::SystemTime, Generation)> =
        std::fs::read_dir("/nix/var/nix/profiles")
            .into_iter()
            .flatten()
            .flatten()
            .filter_map(|e| {
                let name = e.file_name().to_string_lossy().into_owned();
                let id = name
                    .strip_prefix("system-")?
                    .strip_suffix("-link")?
                    .to_string();
                let modified = e.path().symlink_metadata().ok()?.modified().ok()?;
                // the link's own time (date -r would follow it into the store: 1970)
                let secs = modified
                    .duration_since(std::time::UNIX_EPOCH)
                    .ok()?
                    .as_secs();
                let date = output(cmd("date").arg("-d").arg(format!("@{secs}")).arg("+%F %R"))
                    .trim()
                    .to_string();
                let is_current = current
                    .as_deref()
                    .is_some_and(|c| c.as_os_str() == name.as_str());
                Some((
                    modified,
                    Generation {
                        id,
                        date,
                        current: is_current,
                        path: None,
                    },
                ))
            })
            .collect();
    gens.sort_by_key(|g| std::cmp::Reverse(g.0));
    gens.into_iter().map(|(_, g)| g).collect()
}

/// home-manager generations, newest first:
/// "2026-10-15 21:48 : id 120 -> /nix/store/...-home-manager-generation (current)"
pub fn home() -> Vec<Generation> {
    output(cmd("home-manager").arg("generations"))
        .lines()
        .filter_map(|l| {
            let (date, rest) = l.split_once(" : id ")?;
            let (id, rest) = rest.split_once(" -> ")?;
            let current = rest.ends_with("(current)");
            let path = rest.trim_end_matches("(current)").trim().to_string();
            Some(Generation {
                id: id.to_string(),
                date: date.to_string(),
                current,
                path: Some(path),
            })
        })
        .collect()
}

pub fn run(target: Option<Target>, generation: Option<&str>) -> Result<()> {
    match target {
        None => {
            ui::step("NixOS generations (newest first)");
            for g in system().iter().take(8) {
                println!(
                    "  {:>4}  {}{}",
                    g.id,
                    g.date,
                    if g.current { "  (current)" } else { "" }
                );
            }
            ui::heading("Home-manager generations");
            for g in home().iter().take(8) {
                println!(
                    "  {:>4}  {}{}",
                    g.id,
                    g.date,
                    if g.current { "  (current)" } else { "" }
                );
            }
            println!();
            ui::note("nx rollback os [N] | nx rollback home [N]");
            Ok(())
        }
        Some(Target::Os) => os(generation),
        Some(Target::Home) => home_to(generation),
    }
}

pub fn os(generation: Option<&str>) -> Result<()> {
    let mut c = cmd("nh");
    c.args(["os", "rollback"]);
    if let Some(g) = generation {
        c.args(["--to", g]);
    }
    sh::run_or_exit(&mut c)
}

/// Activate a home generation (the previous one by default).
pub fn home_to(generation: Option<&str>) -> Result<()> {
    let gens = home();
    let target = match generation {
        Some(id) => gens.iter().find(|g| g.id == id),
        None => gens.get(1),
    };
    let Some(g) = target else {
        bail!("nx rollback home: no such generation")
    };
    let path = g.path.as_deref().context("generation has no path")?;
    ui::step(&format!("Activating home generation {} ({})", g.id, g.date));
    sh::run_or_exit(&mut cmd(&format!("{path}/activate")))
}
