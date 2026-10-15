//! Terminal output in nh's style: a green `>` for each step, bold headings, ✔ / ! for
//! results. Colours only when stdout is a terminal and NO_COLOR is unset.

use std::io::IsTerminal;
use std::sync::OnceLock;

fn enabled() -> bool {
    static ON: OnceLock<bool> = OnceLock::new();
    *ON.get_or_init(|| std::io::stdout().is_terminal() && std::env::var_os("NO_COLOR").is_none())
}

fn code(c: &'static str) -> &'static str {
    if enabled() { c } else { "" }
}

pub fn bold() -> &'static str {
    code("\x1b[1m")
}
pub fn dim() -> &'static str {
    code("\x1b[2m")
}
pub fn reset() -> &'static str {
    code("\x1b[0m")
}
pub fn red() -> &'static str {
    code("\x1b[31m")
}
pub fn green() -> &'static str {
    code("\x1b[32m")
}
pub fn yellow() -> &'static str {
    code("\x1b[33m")
}
pub fn blue() -> &'static str {
    code("\x1b[34m")
}

pub fn step(msg: &str) {
    println!("{}{}>{} {msg}", bold(), green(), reset());
}

pub fn heading(msg: &str) {
    println!("\n{}{msg}{}", bold(), reset());
}

pub fn note(msg: &str) {
    println!("  {}{msg}{}", dim(), reset());
}

pub fn good(msg: &str) {
    println!("  {}✔{} {msg}", green(), reset());
}

pub fn caution(msg: &str) {
    println!("  {}!{} {msg}", yellow(), reset());
}

pub fn err(msg: &str) {
    // stderr gets colour whenever stdout does; good enough for a personal tool
    eprintln!("{}{}error:{} {msg}", bold(), red(), reset());
}

/// Colour for a byte count: red from 1 GiB, yellow from 100 MiB.
pub fn size_colour(bytes: u64) -> &'static str {
    if bytes >= 1 << 30 {
        red()
    } else if bytes >= 100 << 20 {
        yellow()
    } else {
        ""
    }
}

/// 1.5G / 230M / 12K, like `numfmt --to=iec`, with a B suffix.
pub fn human(bytes: u64) -> String {
    const UNITS: [&str; 5] = ["", "K", "M", "G", "T"];
    let mut v = bytes as f64;
    let mut i = 0;
    while v >= 1024.0 && i < UNITS.len() - 1 {
        v /= 1024.0;
        i += 1;
    }
    if i == 0 {
        format!("{bytes}B")
    } else if v < 10.0 {
        format!("{:.1}{}B", v, UNITS[i])
    } else {
        format!("{:.0}{}B", v, UNITS[i])
    }
}

/// 1.5 GiB / 230 MiB / 12 KiB, used by `nx apps`.
pub fn human_binary(bytes: u64) -> String {
    let b = bytes as f64;
    if b >= (1u64 << 30) as f64 {
        format!("{:.1} GiB", b / (1u64 << 30) as f64)
    } else if b >= (1u64 << 20) as f64 {
        format!("{:.0} MiB", b / (1u64 << 20) as f64)
    } else {
        format!("{:.0} KiB", b / 1024.0)
    }
}
