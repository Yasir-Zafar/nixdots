use crate::sh::{self, cmd};
use crate::ui;
use anyhow::Result;
use clap::ValueEnum;

#[derive(Clone, Copy, ValueEnum)]
pub enum Action {
    Check,
    Update,
    Devices,
    History,
    Bios,
}

pub fn run(action: Action) -> Result<()> {
    match action {
        Action::Check => {
            ui::step("Checking for firmware updates");
            sh::run(cmd("fwupdmgr").args(["refresh", "--force"]))?;
            // exit code 2 just means "nothing to update"
            sh::run(cmd("fwupdmgr").arg("get-updates"))?;
        }
        Action::Update => {
            ui::step("Installing firmware updates");
            sh::run_or_exit(cmd("fwupdmgr").arg("update"))?;
        }
        Action::Devices => {
            ui::step("Firmware devices");
            sh::run_or_exit(cmd("fwupdmgr").arg("get-devices"))?;
        }
        Action::History => {
            ui::step("Firmware history");
            sh::run_or_exit(cmd("fwupdmgr").arg("get-history"))?;
        }
        Action::Bios => {
            ui::step("BIOS");
            for f in [
                "sys_vendor",
                "product_name",
                "bios_vendor",
                "bios_version",
                "bios_date",
            ] {
                let v =
                    std::fs::read_to_string(format!("/sys/class/dmi/id/{f}")).unwrap_or_default();
                println!("  {}{f:<13}{} {}", ui::bold(), ui::reset(), v.trim());
            }
        }
    }
    Ok(())
}
