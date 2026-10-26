//! nh wrappers: nx os / nx home / nx build.

use crate::sh::{Paths, cmd, run_guarded_or_exit};
use crate::{HomeMode, OsMode};
use anyhow::Result;

pub fn os(p: &Paths, mode: OsMode, extra: &[String]) -> Result<()> {
    let mut c = cmd("nh");
    match mode {
        OsMode::Build => c
            .args(["os", "build"])
            .arg(&p.os)
            .arg("-o")
            .arg(p.links.join("os")),
        OsMode::Switch => c.args(["os", "switch"]).arg(&p.os),
        OsMode::Boot => c.args(["os", "boot"]).arg(&p.os),
        OsMode::Test => c.args(["os", "test"]).arg(&p.os),
    };
    run_guarded_or_exit(c.args(extra))
}

pub fn home(p: &Paths, mode: HomeMode, backup: bool) -> Result<()> {
    let mut c = cmd("nh");
    match mode {
        HomeMode::Switch => c.args(["home", "switch"]).arg(&p.hm),
        HomeMode::Build => c
            .args(["home", "build"])
            .arg(&p.hm)
            .arg("-o")
            .arg(p.links.join("home")),
    };
    if backup {
        c.env("HOME_MANAGER_BACKUP_EXT", "bak");
    }
    run_guarded_or_exit(&mut c)
}
