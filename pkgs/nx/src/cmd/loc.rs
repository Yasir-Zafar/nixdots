//! nx loc: lines of code in the config and in nx itself, by category.
//! Files come from git (tracked + new, minus .gitignore), so build output and the local
//! docs never count. Also left out: lock files, the icon/theme assets, the encrypted
//! secrets, the generated hardware-configuration.nix, and prose (markdown, txt).

use crate::sh::{Paths, cmd, output_checked};
use crate::ui;
use anyhow::Result;

#[derive(Default, Clone)]
pub struct Count {
    pub files: usize,
    pub code: usize,
    pub comments: usize,
}

impl Count {
    pub fn total(&self) -> usize {
        self.code + self.comments
    }
    fn add(&mut self, o: &Count) {
        self.files += o.files;
        self.code += o.code;
        self.comments += o.comments;
    }
}

pub struct Category {
    pub name: &'static str,
    pub count: Count,
}

pub struct Group {
    pub name: &'static str,
    pub categories: Vec<Category>,
}

impl Group {
    pub fn total(&self) -> Count {
        let mut c = Count::default();
        for cat in &self.categories {
            c.add(&cat.count);
        }
        c
    }
}

/// (group, category) for a path, first match wins. None = not counted.
const RULES: &[(&str, &str, &str)] = &[
    ("pkgs/nx/src/cmd/", "nx", "Rust: commands"),
    ("pkgs/nx/src/tui/", "nx", "Rust: TUI"),
    ("pkgs/nx/src/", "nx", "Rust: CLI, output, process glue"),
    ("pkgs/nx/", "nx", "Packaging and completions"),
    ("pkgs/nx-sh/", "nx", "Bash fallback (nx-sh)"),
    ("modules/nixos/", "Config", "System modules"),
    ("modules/home/nixvim/", "Config", "Neovim (nixvim)"),
    ("modules/home/", "Config", "Home modules"),
    ("nix/", "Config", "Flakes, host, user, shared lib"),
    ("hm/", "Config", "Flakes, host, user, shared lib"),
    ("hosts/", "Config", "Flakes, host, user, shared lib"),
    ("home/", "Config", "Flakes, host, user, shared lib"),
    ("lib/", "Config", "Flakes, host, user, shared lib"),
    ("templates/", "Config", "Project templates"),
    ("pkgs/", "Config", "Other packages"),
    ("", "Config", "CI and repo settings"),
];

fn skipped(path: &str) -> bool {
    let name = path.rsplit('/').next().unwrap_or(path);
    path.starts_with("assets/")
        || path.starts_with("secrets/")
        || name.ends_with(".lock")
        || name == "hardware-configuration.nix"
        || [".md", ".txt", ".gitignore", ".editorconfig"]
            .iter()
            .any(|e| name.ends_with(e))
}

/// Comment marker for a file, or None when it isn't source we count.
fn comment_marker(path: &str) -> Option<&'static str> {
    let name = path.rsplit('/').next().unwrap_or(path);
    let ext = name.rsplit_once('.').map(|(_, e)| e).unwrap_or("");
    match ext {
        "rs" => Some("//"),
        "nix" | "sh" | "fish" | "toml" | "yml" | "yaml" | "envrc" => Some("#"),
        _ if name == "_nx" || name == ".envrc" => Some("#"),
        _ => None,
    }
}

fn count_file(path: &std::path::Path, marker: &str) -> Count {
    let text = std::fs::read_to_string(path).unwrap_or_default();
    let mut c = Count {
        files: 1,
        ..Count::default()
    };
    for line in text.lines().map(str::trim).filter(|l| !l.is_empty()) {
        if line.starts_with(marker) || line.starts_with("/*") || line.starts_with("* ") {
            c.comments += 1;
        } else {
            c.code += 1;
        }
    }
    c
}

pub fn collect(p: &Paths) -> Result<Vec<Group>> {
    let files = output_checked(cmd("git").arg("-C").arg(&p.dots).args([
        "ls-files",
        "--cached",
        "--others",
        "--exclude-standard",
    ]))?;
    let mut groups: Vec<Group> = vec![
        Group {
            name: "Config",
            categories: vec![],
        },
        Group {
            name: "nx",
            categories: vec![],
        },
    ];
    for path in files.lines().filter(|f| !skipped(f)) {
        let Some(marker) = comment_marker(path) else {
            continue;
        };
        let full = p.dots.join(path);
        if !full.is_file() {
            continue; // deleted but not yet committed
        }
        let &(_, group, category) = RULES
            .iter()
            .find(|(prefix, _, _)| path.starts_with(prefix))
            .expect("catch-all rule");
        let g = groups
            .iter_mut()
            .find(|g| g.name == group)
            .expect("known group");
        let count = count_file(&full, marker);
        match g.categories.iter_mut().find(|c| c.name == category) {
            Some(c) => c.count.add(&count),
            None => g.categories.push(Category {
                name: category,
                count,
            }),
        }
    }
    for g in &mut groups {
        g.categories
            .sort_by_key(|c| std::cmp::Reverse(c.count.total()));
    }
    Ok(groups)
}

pub fn print(p: &Paths) -> Result<()> {
    let groups = collect(p)?;
    let row = |name: &str, c: &Count, style: &str| {
        println!(
            "  {style}{name:<34}{:>6} {:>8} {:>9} {:>8}{}",
            c.files,
            c.code,
            c.comments,
            c.total(),
            ui::reset()
        );
    };
    let mut grand = Count::default();
    for g in &groups {
        ui::heading(g.name);
        println!(
            "  {}{:<34}{:>6} {:>8} {:>9} {:>8}{}",
            ui::dim(),
            "",
            "files",
            "code",
            "comments",
            "total",
            ui::reset()
        );
        for c in &g.categories {
            row(c.name, &c.count, "");
        }
        let t = g.total();
        row(&format!("{} total", g.name), &t, ui::bold());
        grand.add(&t);
    }
    println!();
    ui::step(&format!(
        "{} lines in {} files ({} code, {} comments)",
        grand.total(),
        grand.files,
        grand.code,
        grand.comments
    ));
    ui::note(
        "not counted: blank lines, lock files, assets, secrets, hardware-configuration.nix, docs/markdown, build output",
    );
    Ok(())
}
