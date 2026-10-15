//! nx try: boot-test another greeter. Swaps the greeter import in
//! modules/nixos/desktop/default.nix, builds, and (after you confirm) runs `nh os boot`,
//! then restores the file. It never touches the running session.

use crate::sh::{self, Paths, cmd};
use crate::ui;
use anyhow::{Context, Result, bail};
use clap::ValueEnum;
use std::path::PathBuf;

#[derive(Clone, Copy, ValueEnum)]
pub enum Greeter {
    Tuigreet,
    #[value(alias = "ldm")]
    Lightdm,
    #[value(alias = "g")]
    Gdm,
    #[value(alias = "l")]
    Ly,
    #[value(aliases = ["default", "sysc-greet"])]
    Sysc,
}

impl Greeter {
    fn file(self) -> &'static str {
        match self {
            Greeter::Tuigreet => "tuigreet.nix",
            Greeter::Lightdm => "lightdm.nix",
            Greeter::Gdm => "gdm.nix",
            Greeter::Ly => "ly.nix",
            Greeter::Sysc => "sysc-greet.nix",
        }
    }
}

/// Puts desktop/default.nix back however `run` ends (error, abort or success).
struct Restore {
    file: PathBuf,
    original: String,
    dots: PathBuf,
}

impl Drop for Restore {
    fn drop(&mut self) {
        let _ = std::fs::write(&self.file, &self.original);
        sh::succeeds(
            cmd("git")
                .arg("-C")
                .arg(&self.dots)
                .args(["add", "-N"])
                .arg(&self.file),
        );
    }
}

pub fn run(p: &Paths, greeter: Greeter) -> Result<()> {
    let file = greeter.file();
    let name = file.trim_end_matches(".nix");
    if !p.desktop.join("greeters").join(file).exists() {
        bail!(
            "nx try: {} not found",
            p.desktop.join("greeters").join(file).display()
        );
    }
    let cfg = p.desktop.join("default.nix");
    let original =
        std::fs::read_to_string(&cfg).with_context(|| format!("reading {}", cfg.display()))?;
    let swapped = original.replace("./greeters/sysc-greet.nix", &format!("./greeters/{file}"));
    if !swapped.contains(&format!("greeters/{file}")) {
        bail!(
            "nx try: could not find the greeter import in {}",
            cfg.display()
        );
    }
    let _restore = Restore {
        file: cfg.clone(),
        original,
        dots: p.dots.clone(),
    };
    // Ctrl+C stops nh (it gets the signal too) but not nx, so the restore still runs
    let _ = ctrlc::set_handler(|| {});
    std::fs::write(&cfg, swapped)?;

    ui::step(&format!("Building {name} (nothing is activated yet)"));
    // plain `run` + bail (not run_or_exit): exiting directly would skip the restore above
    if !sh::run(
        cmd("nh")
            .args(["os", "build"])
            .arg(&p.os)
            .arg("-o")
            .arg(p.links.join("os")),
    )? {
        bail!("build failed, desktop/default.nix restored");
    }
    if !sh::confirm(&format!(
        "Make '{name}' the default boot entry (reboot to try it)?"
    )) {
        ui::step("Aborted, desktop/default.nix restored");
        return Ok(());
    }
    if !sh::run(cmd("nh").args(["os", "boot"]).arg(&p.os))? {
        bail!("nh os boot failed, desktop/default.nix restored");
    }
    println!();
    ui::step(&format!(
        "Reboot to see {name}. To go back: nx os boot  (or choose the previous generation in the boot menu)."
    ));
    Ok(())
}
