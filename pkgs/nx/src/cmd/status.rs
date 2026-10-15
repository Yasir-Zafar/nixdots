//! nx status: lock ages, nixpkgs revisions, git state, disk.

use crate::sh::{Paths, cmd, output};
use crate::ui;
use anyhow::{Context, Result};
use std::path::Path;

pub struct Lock {
    pub name: String,
    pub days: u64,
    pub changed: String,
    pub nixpkgs: String,
}

pub struct Status {
    pub locks: Vec<Lock>,
    pub git: Vec<String>,
    /// `df -h /`: header line, then the root filesystem
    pub disk: Vec<String>,
    pub disk_percent: u8,
}

/// The nixpkgs revision a flake.lock pins.
pub fn nixpkgs_rev(lock: &Path) -> Result<String> {
    let text =
        std::fs::read_to_string(lock).with_context(|| format!("reading {}", lock.display()))?;
    let json: serde_json::Value = serde_json::from_str(&text)?;
    let node = json["nodes"]["root"]["inputs"]["nixpkgs"]
        .as_str()
        .unwrap_or("nixpkgs");
    Ok(json["nodes"][node]["locked"]["rev"]
        .as_str()
        .unwrap_or("?")
        .to_string())
}

pub fn collect(p: &Paths) -> Result<Status> {
    let mut locks = Vec::new();
    for flake in [&p.os, &p.hm] {
        let file = flake.join("flake.lock");
        let age = std::fs::metadata(&file)?
            .modified()?
            .elapsed()
            .unwrap_or_default();
        locks.push(Lock {
            name: flake
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .into_owned(),
            days: age.as_secs() / 86400,
            changed: output(cmd("date").arg("-r").arg(&file).arg("+%F %R"))
                .trim()
                .to_string(),
            nixpkgs: nixpkgs_rev(&file)?.chars().take(8).collect(),
        });
    }
    let git = output(
        cmd("git")
            .arg("-C")
            .arg(&p.dots)
            .args(["status", "--short", "--branch"]),
    )
    .lines()
    .take(15)
    .map(String::from)
    .collect();
    let disk: Vec<String> = output(cmd("df").args(["-h", "/"]))
        .lines()
        .map(String::from)
        .collect();
    let disk_percent = disk
        .get(1)
        .and_then(|l| l.split_whitespace().nth(4))
        .and_then(|p| p.trim_end_matches('%').parse().ok())
        .unwrap_or(0);
    Ok(Status {
        locks,
        git,
        disk,
        disk_percent,
    })
}

pub fn print(p: &Paths) -> Result<()> {
    let s = collect(p)?;
    ui::step("Flakes");
    for l in &s.locks {
        let col = match l.days {
            30.. => ui::red(),
            7.. => ui::yellow(),
            _ => ui::green(),
        };
        println!(
            "  {b}{:<4}{r} lock {col}{} days old{r} ({})  nixpkgs {b}{}{r}",
            l.name,
            l.days,
            l.changed,
            l.nixpkgs,
            b = ui::bold(),
            r = ui::reset()
        );
    }
    ui::heading("Git");
    for line in &s.git {
        println!("  {line}");
    }
    ui::heading("Disk");
    for (i, line) in s.disk.iter().enumerate() {
        let col = match (i, s.disk_percent) {
            (0, _) => "",
            (_, 90..) => ui::red(),
            (_, 75..) => ui::yellow(),
            _ => "",
        };
        println!("  {col}{line}{}", ui::reset());
    }
    Ok(())
}
