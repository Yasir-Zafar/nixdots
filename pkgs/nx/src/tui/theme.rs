//! Gruvbox dark (medium), the same palette stylix uses for the rest of the desktop.

use ratatui::style::{Color, Modifier, Style};

pub const BG0: Color = Color::Rgb(0x28, 0x28, 0x28);
pub const BG2: Color = Color::Rgb(0x50, 0x49, 0x45);
pub const GRAY: Color = Color::Rgb(0x92, 0x83, 0x74);
pub const FG: Color = Color::Rgb(0xeb, 0xdb, 0xb2);
pub const FG4: Color = Color::Rgb(0xa8, 0x99, 0x84);
pub const RED: Color = Color::Rgb(0xfb, 0x49, 0x34);
pub const GREEN: Color = Color::Rgb(0xb8, 0xbb, 0x26);
pub const YELLOW: Color = Color::Rgb(0xfa, 0xbd, 0x2f);
pub const BLUE: Color = Color::Rgb(0x83, 0xa5, 0x98);
pub const PURPLE: Color = Color::Rgb(0xd3, 0x86, 0x9b);
pub const AQUA: Color = Color::Rgb(0x8e, 0xc0, 0x7c);
pub const ORANGE: Color = Color::Rgb(0xfe, 0x80, 0x19);

pub fn text() -> Style {
    Style::new().fg(FG)
}
pub fn muted() -> Style {
    Style::new().fg(GRAY)
}
pub fn heading() -> Style {
    Style::new().fg(AQUA).add_modifier(Modifier::BOLD)
}
pub fn number() -> Style {
    Style::new().fg(ORANGE)
}
pub fn good() -> Style {
    Style::new().fg(GREEN).add_modifier(Modifier::BOLD)
}
pub fn warn() -> Style {
    Style::new().fg(YELLOW).add_modifier(Modifier::BOLD)
}
pub fn bad() -> Style {
    Style::new().fg(RED).add_modifier(Modifier::BOLD)
}
pub fn selected() -> Style {
    Style::new().bg(BG2).fg(YELLOW).add_modifier(Modifier::BOLD)
}
/// A key "badge" in the help bar.
pub fn key(colour: Color) -> Style {
    Style::new().bg(colour).fg(BG0).add_modifier(Modifier::BOLD)
}

/// Red from 1 GiB, yellow from 100 MiB, plain below.
pub fn size(bytes: u64) -> Color {
    if bytes >= 1 << 30 {
        RED
    } else if bytes >= 100 << 20 {
        YELLOW
    } else {
        FG
    }
}
