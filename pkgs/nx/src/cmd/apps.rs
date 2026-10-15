//! nx apps: installed programs (home profile + system profile) ranked by the space only
//! they need. "Unique" is the part of an app's closure that no other installed package
//! reaches, so shared libraries don't count; removing the app frees about that much.

use crate::sh::{self, cmd, home};
use crate::ui;
use anyhow::{Context, Result};
use std::collections::{HashMap, HashSet};
use std::path::Path;

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum Scope {
    All,
    Home,
    System,
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Class {
    Huge,
    Large,
    Medium,
    Small,
}

impl Class {
    pub fn of(unique: u64) -> Class {
        match unique {
            u if u >= 1 << 30 => Class::Huge,
            u if u >= 250 << 20 => Class::Large,
            u if u >= 50 << 20 => Class::Medium,
            _ => Class::Small,
        }
    }
    pub fn name(self) -> &'static str {
        ["Huge", "Large", "Medium", "Small"][self as usize]
    }
    pub fn range(self) -> &'static str {
        [">= 1 GiB", "250 MiB - 1 GiB", "50 - 250 MiB", "< 50 MiB"][self as usize]
    }
}

pub struct App {
    pub name: String,
    pub unique: u64,
    pub closure: u64,
    pub home: bool,
    pub system: bool,
}

impl App {
    pub fn class(&self) -> Class {
        Class::of(self.unique)
    }
    pub fn origin(&self) -> &'static str {
        match (self.home, self.system) {
            (true, true) => "home+system",
            (true, false) => "home",
            _ => "system",
        }
    }
    pub fn in_scope(&self, scope: Scope) -> bool {
        match scope {
            Scope::All => true,
            Scope::Home => self.home,
            Scope::System => self.system,
        }
    }
}

/// "/nix/store/<hash>-foo-1.2-bin" -> "foo-1.2": outputs of one package share a name.
fn group_name(path: &str) -> String {
    let base = path.rsplit('/').next().unwrap_or(path);
    let mut name = base.split_once('-').map_or(base, |(_, rest)| rest);
    for suffix in [
        "-bin", "-man", "-doc", "-dev", "-info", "-lib", "-devdoc", "-out",
    ] {
        if let Some(stripped) = name.strip_suffix(suffix) {
            name = stripped;
            break;
        }
    }
    // some packages end in a long build number (antigravity's 16 digits)
    if let Some((head, tail)) = name.rsplit_once('-')
        && tail.len() >= 12
        && tail.chars().all(|c| c.is_ascii_digit())
    {
        name = head;
    }
    name.to_string()
}

struct Group {
    roots: Vec<String>,
    is_app: bool,
    home: bool,
    system: bool,
}

pub fn collect() -> Result<Vec<App>> {
    let home_env =
        std::fs::canonicalize(home().join(".local/state/nix/profiles/home-manager/home-path"))
            .or_else(|_| std::fs::canonicalize(home().join(".nix-profile")))
            .context("no home-manager profile")?;
    let sys_env = std::fs::canonicalize("/run/current-system/sw")?;

    // direct packages of both profiles, grouped by package name
    let mut groups: HashMap<String, Group> = HashMap::new();
    let mut order = Vec::new();
    for (is_home, env) in [(true, &home_env), (false, &sys_env)] {
        let refs = sh::output_checked(cmd("nix-store").args(["-q", "--references"]).arg(env))?;
        for path in refs.lines().filter(|l| !l.is_empty()) {
            let name = group_name(path);
            let g = groups.entry(name.clone()).or_insert_with(|| {
                order.push(name.clone());
                Group {
                    roots: vec![],
                    is_app: false,
                    home: false,
                    system: false,
                }
            });
            if !g.roots.iter().any(|r| r == path) {
                g.roots.push(path.to_string());
            }
            let p = Path::new(path);
            g.is_app |= p.join("bin").is_dir() || p.join("share/applications").is_dir();
            if is_home {
                g.home = true
            } else {
                g.system = true
            }
        }
    }

    // sizes and references of everything those packages pull in
    let roots: Vec<&str> = groups
        .values()
        .flat_map(|g| g.roots.iter().map(String::as_str))
        .collect();
    let json = sh::output_checked(
        cmd("nix")
            .args(["path-info", "-r", "--json", "--json-format", "1"])
            .args(&roots),
    )?;
    let info: serde_json::Value = serde_json::from_str(&json).context("parsing nix path-info")?;
    let info = info
        .as_object()
        .context("unexpected nix path-info output")?;
    let size = |p: &str| info.get(p).and_then(|v| v["narSize"].as_u64()).unwrap_or(0);
    let refs = |p: &str| -> Vec<String> {
        info.get(p)
            .and_then(|v| v["references"].as_array())
            .map(|a| {
                a.iter()
                    .filter_map(|r| r.as_str())
                    .filter(|r| *r != p)
                    .map(String::from)
                    .collect()
            })
            .unwrap_or_default()
    };

    // closure of each group; count how many groups reach each path
    let mut closures: HashMap<&str, HashSet<String>> = HashMap::new();
    let mut reach: HashMap<String, u32> = HashMap::new();
    for name in &order {
        let mut seen = HashSet::new();
        let mut stack = groups[name].roots.clone();
        while let Some(p) = stack.pop() {
            if seen.insert(p.clone()) {
                stack.extend(refs(&p));
            }
        }
        for p in &seen {
            *reach.entry(p.clone()).or_default() += 1;
        }
        closures.insert(name, seen);
    }

    let mut apps: Vec<App> = order
        .iter()
        .filter(|n| groups[*n].is_app)
        .map(|n| {
            let c = &closures[n.as_str()];
            App {
                name: n.clone(),
                unique: c.iter().filter(|p| reach[*p] == 1).map(|p| size(p)).sum(),
                closure: c.iter().map(|p| size(p)).sum(),
                home: groups[n].home,
                system: groups[n].system,
            }
        })
        .collect();
    apps.sort_by(|a, b| b.unique.cmp(&a.unique).then_with(|| a.name.cmp(&b.name)));
    Ok(apps)
}

pub fn print(scope: Scope, show_all: bool) -> Result<()> {
    ui::step("Measuring installed packages");
    let apps: Vec<App> = collect()?
        .into_iter()
        .filter(|a| a.in_scope(scope))
        .collect();
    let colour = |c: Class| [ui::red(), ui::yellow(), ui::blue(), ui::green()][c as usize];
    for class in [Class::Huge, Class::Large, Class::Medium, Class::Small] {
        let members: Vec<&App> = apps.iter().filter(|a| a.class() == class).collect();
        if members.is_empty() {
            continue;
        }
        let total: u64 = members.iter().map(|a| a.unique).sum();
        let n = members.len();
        println!(
            "\n{}{}{}{}  {}  {}·  {n} app{}  ·  {}{}",
            ui::bold(),
            colour(class),
            class.name(),
            ui::reset(),
            class.range(),
            ui::dim(),
            if n == 1 { "" } else { "s" },
            ui::human_binary(total),
            ui::reset()
        );
        if class == Class::Small && !show_all {
            ui::note("(--all lists them)");
            continue;
        }
        for a in members {
            println!(
                "  {}{:>10}{}  {:<40} {:<12} {}closure {}{}",
                colour(class),
                ui::human_binary(a.unique),
                ui::reset(),
                a.name,
                a.origin(),
                ui::dim(),
                ui::human_binary(a.closure),
                ui::reset()
            );
        }
    }
    let total: u64 = apps.iter().map(|a| a.unique).sum();
    println!();
    ui::step(&format!(
        "{} apps, {} that only they use",
        apps.len(),
        ui::human_binary(total)
    ));
    ui::note("size = space no other installed program needs (shared libraries are not counted).");
    ui::note(
        "closure = everything the app pulls in, shared or not. Remove an app in its module, then nx clean.",
    );
    Ok(())
}
