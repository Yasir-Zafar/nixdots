//! nx: one command for the ~/dots update lifecycle. It rebuilds through nh, reports on the
//! system, and has a TUI (`nx tui`). It always passes ~/dots/nix and ~/dots/hm explicitly,
//! so it doesn't depend on NH_OS_FLAKE / NH_HOME_FLAKE being set.

mod cmd;
mod sh;
mod tui;
mod ui;

use clap::{Parser, Subcommand, ValueEnum};

#[derive(Parser)]
#[command(
    name = "nx",
    version,
    about = "nix update management for ~/dots",
    arg_required_else_help = true
)]
struct Cli {
    #[command(subcommand)]
    command: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    /// Update flake.lock in nix/ and hm/ (all inputs, or just those named)
    #[command(visible_alias = "up")]
    Update { inputs: Vec<String> },
    /// nixos-rebuild via nh: switch (default) | boot | test | build; extra args go to nh
    Os {
        #[arg(value_enum, default_value_t = OsMode::Switch)]
        mode: OsMode,
        #[arg(trailing_var_arg = true, allow_hyphen_values = true)]
        extra: Vec<String>,
    },
    /// home-manager via nh: switch (default) | build
    Home {
        #[arg(value_enum, default_value_t = HomeMode::Switch)]
        mode: HomeMode,
        /// move files that would be overwritten to <name>.bak instead of failing
        #[arg(short = 'b', long = "backup")]
        backup: bool,
    },
    /// Update, then os switch, then home switch
    All,
    /// Build os and home without activating (safe check)
    Build,
    /// nh clean all, keeping the newest 4 generations by default
    #[command(visible_alias = "gc")]
    Clean {
        #[arg(trailing_var_arg = true, allow_hyphen_values = true)]
        nh_args: Vec<String>,
    },
    /// nix store optimise (hard-links identical files)
    #[command(visible_aliases = ["optimize", "opt"])]
    Optimise,
    /// Package changes since boot (booted vs current system)
    Diff,
    /// Lock ages, nixpkgs revs, uncommitted changes, disk space
    #[command(visible_alias = "st")]
    Status,
    /// Installed apps by the space only they use, in size classes (huge = IDEs, big apps)
    #[command(visible_alias = "app")]
    Apps {
        /// also list the small ones
        #[arg(short, long)]
        all: bool,
        #[arg(long, conflicts_with = "system")]
        home: bool,
        #[arg(long)]
        system: bool,
    },
    /// What uses space and what is safe to delete; `clean` deletes regenerable caches
    #[command(visible_alias = "disk")]
    Storage(cmd::storage::Args),
    /// Firmware via fwupd: check (default) | update | devices | history | bios
    #[command(visible_alias = "fw")]
    Firmware {
        #[arg(value_enum, default_value_t = cmd::firmware::Action::Check)]
        action: cmd::firmware::Action,
    },
    /// Checks for the usual problems (env vars, stub flake, sops key, core dumps, backups, reboot needed)
    #[command(visible_alias = "dr")]
    Doctor,
    /// List generations; `os [N]` / `home [N]` go back (previous one by default)
    #[command(visible_alias = "rb")]
    Rollback {
        #[arg(value_enum)]
        target: Option<cmd::rollback::Target>,
        generation: Option<String>,
    },
    /// Boot-test another greeter: makes it the default boot entry, never touches the running session
    Try {
        #[arg(value_enum)]
        greeter: cmd::try_greeter::Greeter,
    },
    /// Lines of code in the config and in nx, by category, with totals
    #[command(visible_alias = "lines")]
    Loc,
    /// statix + deadnix over the repo
    Lint,
    /// alejandra over the repo
    Fmt,
    /// Interactive overview: status, apps, storage, doctor, generations, and the actions above
    Tui,
}

#[derive(Clone, Copy, ValueEnum)]
pub enum OsMode {
    Switch,
    Boot,
    Test,
    Build,
}

#[derive(Clone, Copy, ValueEnum)]
pub enum HomeMode {
    Switch,
    Build,
}

fn main() {
    // die quietly on a closed pipe (`nx apps | head`) instead of panicking, like other CLIs
    // SAFETY: setting a signal disposition to its default before any threads start
    unsafe {
        libc::signal(libc::SIGPIPE, libc::SIG_DFL);
    }
    let cli = Cli::parse();
    let paths = sh::Paths::new();
    let result = match cli.command {
        Cmd::Update { inputs } => cmd::update::run(&paths, &inputs),
        Cmd::Os { mode, extra } => cmd::rebuild::os(&paths, mode, &extra),
        Cmd::Home { mode, backup } => cmd::rebuild::home(&paths, mode, backup),
        Cmd::All => cmd::update::run(&paths, &[])
            .and_then(|_| cmd::rebuild::os(&paths, OsMode::Switch, &[]))
            .and_then(|_| cmd::rebuild::home(&paths, HomeMode::Switch, false)),
        Cmd::Build => cmd::rebuild::os(&paths, OsMode::Build, &[])
            .and_then(|_| cmd::rebuild::home(&paths, HomeMode::Build, false)),
        Cmd::Clean { nh_args } => cmd::tools::clean(&nh_args),
        Cmd::Optimise => cmd::tools::optimise(),
        Cmd::Diff => cmd::tools::diff(),
        Cmd::Status => cmd::status::print(&paths),
        Cmd::Apps { all, home, system } => {
            let scope = if home {
                cmd::apps::Scope::Home
            } else if system {
                cmd::apps::Scope::System
            } else {
                cmd::apps::Scope::All
            };
            cmd::apps::print(scope, all)
        }
        Cmd::Storage(args) => cmd::storage::run(&args),
        Cmd::Firmware { action } => cmd::firmware::run(action),
        Cmd::Doctor => cmd::doctor::print(&paths),
        Cmd::Rollback { target, generation } => cmd::rollback::run(target, generation.as_deref()),
        Cmd::Try { greeter } => cmd::try_greeter::run(&paths, greeter),
        Cmd::Loc => cmd::loc::print(&paths),
        Cmd::Lint => cmd::tools::lint(&paths),
        Cmd::Fmt => cmd::tools::fmt(&paths),
        Cmd::Tui => tui::run(&paths),
    };
    if let Err(e) = result {
        ui::err(&format!("{e:#}"));
        std::process::exit(1);
    }
}
