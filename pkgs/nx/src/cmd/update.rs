use crate::sh::{self, Paths, cmd};
use crate::ui;
use anyhow::Result;

pub fn run(p: &Paths, inputs: &[String]) -> Result<()> {
    for flake in [&p.os, &p.hm] {
        let name = flake.file_name().unwrap_or_default().to_string_lossy();
        ui::step(&format!("Updating {name}/flake.lock"));
        if inputs.is_empty() {
            sh::run_guarded_or_exit(cmd("nix").args(["flake", "update", "--flake"]).arg(flake))?;
        } else if !sh::run_guarded(
            cmd("nix")
                .args(["flake", "update"])
                .args(inputs)
                .arg("--flake")
                .arg(flake),
        )? {
            ui::caution(&format!("skipped: not all of those inputs exist in {name}"));
        }
    }
    ui::step("Done. Nothing changes until you build and switch (nx build, nx all)");
    Ok(())
}
