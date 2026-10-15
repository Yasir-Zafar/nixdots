//! nx doctor: checks for the usual problems.

use crate::cmd::status::nixpkgs_rev;
use crate::sh::{Paths, cmd, home, output};
use crate::ui;
use anyhow::Result;
use std::path::{Path, PathBuf};

pub struct Check {
    pub section: &'static str,
    pub ok: bool,
    pub message: String,
}

pub fn collect(p: &Paths) -> Result<Vec<Check>> {
    let home = home();
    let mut out = Vec::new();
    let mut check = |section, ok: bool, good: &str, bad: String| {
        out.push(Check {
            section,
            ok,
            message: if ok { good.to_string() } else { bad },
        });
    };

    // session
    let nh_env =
        std::env::var_os("NH_OS_FLAKE").is_some() && std::env::var_os("NH_HOME_FLAKE").is_some();
    check("Session", nh_env, "NH_OS_FLAKE / NH_HOME_FLAKE set",
        "NH_OS_FLAKE/NH_HOME_FLAKE not set: log out and in (nx always passes paths explicitly, so it is unaffected)".into());
    let stub = home.join(".config/home-manager/flake.nix").exists();
    check("Session", !stub, "no stub home-manager flake",
        "stub flake at ~/.config/home-manager: a bare 'nh home switch' would use it instead of ~/dots/hm".into());
    let key = home.join(".config/sops/age/keys.txt").exists();
    check("Session", key, "sops age key present",
        "no sops age key at ~/.config/sops/age/keys.txt: secrets (git email) can't be decrypted; restore it from your backup".into());

    // system
    let same = |f: &str| {
        std::fs::read_link(format!("/run/booted-system/{f}")).ok()
            == std::fs::read_link(format!("/run/current-system/{f}")).ok()
    };
    check(
        "System",
        same("kernel") && same("initrd"),
        "booted kernel matches current generation",
        "reboot needed: running kernel/initrd differ from the current generation".into(),
    );
    let failed = |user: bool| {
        let mut c = cmd("systemctl");
        if user {
            c.arg("--user");
        }
        output(c.args(["--failed", "--no-legend", "--plain"]))
            .lines()
            .count()
    };
    let n = failed(false);
    check(
        "System",
        n == 0,
        "no failed system units",
        format!("{n} failed system unit(s): systemctl --failed"),
    );
    let n = failed(true);
    check(
        "System",
        n == 0,
        "no failed user units",
        format!("{n} failed user unit(s): systemctl --user --failed"),
    );

    // leftovers
    let cores = find(
        &[home.clone(), p.dots.clone(), home.join("AppImages")],
        1,
        |n| {
            n.strip_prefix("core.")
                .is_some_and(|rest| !rest.is_empty() && rest.chars().all(|c| c.is_ascii_digit()))
        },
    );
    if cores.is_empty() {
        check("Leftovers", true, "no stray core.* files", String::new());
    }
    for f in cores {
        let size = std::fs::metadata(&f).map(|m| m.len()).unwrap_or(0);
        check(
            "Leftovers",
            false,
            "",
            format!("core dump: {} ({} apparent)", f.display(), ui::human(size)),
        );
    }
    let dirs = [
        home.clone(),
        home.join(".config"),
        home.join(".icons"),
        home.join(".themes"),
        home.join(".vscode"),
    ];
    let baks: Vec<_> = find(&dirs, 2, |n| n.ends_with(".bak"))
        .into_iter()
        .take(20)
        .collect();
    if baks.is_empty() {
        check(
            "Leftovers",
            true,
            "no *.bak files from home-manager backups",
            String::new(),
        );
    }
    for f in baks {
        check(
            "Leftovers",
            false,
            "",
            format!("backup file: {}", f.display()),
        );
    }

    // repo
    let same_pin = nixpkgs_rev(&p.os.join("flake.lock"))? == nixpkgs_rev(&p.hm.join("flake.lock"))?;
    check(
        "Repo",
        same_pin,
        "nix/ and hm/ pin the same nixpkgs",
        "nix/ and hm/ pin different nixpkgs revisions (nx update fixes it)".into(),
    );
    let dirty = output(
        cmd("git")
            .arg("-C")
            .arg(&p.dots)
            .args(["status", "--porcelain"]),
    )
    .lines()
    .count();
    check(
        "Repo",
        dirty == 0,
        "repo is clean",
        format!("{dirty} uncommitted change(s) in {}", p.dots.display()),
    );

    Ok(out)
}

/// Files under `roots` (down to `depth` levels) whose name matches.
fn find(roots: &[PathBuf], depth: usize, matches: impl Fn(&str) -> bool + Copy) -> Vec<PathBuf> {
    fn walk(
        dir: &Path,
        depth: usize,
        matches: impl Fn(&str) -> bool + Copy,
        out: &mut Vec<PathBuf>,
    ) {
        let Ok(entries) = std::fs::read_dir(dir) else {
            return;
        };
        for e in entries.flatten() {
            let path = e.path();
            let name = e.file_name().to_string_lossy().into_owned();
            if matches(&name) {
                out.push(path.clone());
            }
            // don't follow symlinks (home-manager links point into the store)
            if depth > 1 && e.file_type().is_ok_and(|t| t.is_dir()) {
                walk(&path, depth - 1, matches, out);
            }
        }
    }
    let mut out = Vec::new();
    for r in roots {
        walk(r, depth, matches, &mut out);
    }
    out.sort();
    out.dedup();
    out
}

pub fn print(p: &Paths) -> Result<()> {
    let checks = collect(p)?;
    let mut section = "";
    for c in &checks {
        if c.section != section {
            section = c.section;
            ui::step(section);
        }
        if c.ok {
            ui::good(&c.message)
        } else {
            ui::caution(&c.message)
        }
    }
    let issues = checks.iter().filter(|c| !c.ok).count();
    println!();
    if issues == 0 {
        ui::step("All good");
    } else {
        println!(
            "{}{}!{} {}{issues} thing(s) to look at{}",
            ui::bold(),
            ui::yellow(),
            ui::reset(),
            ui::bold(),
            ui::reset()
        );
    }
    Ok(())
}
