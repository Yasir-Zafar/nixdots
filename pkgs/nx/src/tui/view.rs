//! Drawing, in gruvbox (see theme.rs).

use super::theme::{
    self as t, AQUA, BG1, BG2, BLUE, FG, FG4, GRAY, GREEN, ORANGE, PURPLE, RED, YELLOW,
};
use super::{App, Load, SortBy, Tab, job::Job};
use crate::cmd::apps::Class;
use crate::ui::{human, human_binary};
use ratatui::Frame;
use ratatui::layout::{Constraint, Layout, Rect};
use ratatui::style::{Color, Style};
use ratatui::symbols;
use ratatui::text::{Line, Span};
use ratatui::widgets::{
    Block, BorderType, Cell, Clear, LineGauge, List, ListItem, Paragraph, Row, Sparkline, Table,
    Wrap,
};

fn block(title: &str) -> Block<'_> {
    Block::bordered()
        .border_type(BorderType::Rounded)
        .border_style(Style::new().fg(BG2))
        .title(Span::styled(
            format!(" {title} "),
            Style::new().fg(YELLOW).bold(),
        ))
}

fn class_colour(c: Class) -> Color {
    [RED, YELLOW, BLUE, GREEN][c as usize]
}

/// "Loading…" / error text for data that isn't ready; None when it is.
fn pending<T>(load: &Load<T>, loading: &'static str) -> Option<Paragraph<'static>> {
    match load {
        Load::Ready(_) => None,
        Load::Failed(e) => Some(
            Paragraph::new(format!("could not load: {e}"))
                .style(t::bad())
                .wrap(Wrap { trim: true }),
        ),
        Load::Loading => Some(Paragraph::new(format!("\n  {loading}")).style(t::muted())),
        Load::Idle => Some(Paragraph::new("").style(t::muted())),
    }
}

/// The text shown on Apps / Storage before they're measured.
fn press_enter(what: &str, cost: &str) -> Paragraph<'static> {
    Paragraph::new(vec![
        Line::from(""),
        Line::from(vec![
            Span::styled("  Press ", t::text()),
            Span::styled(" Enter ", t::key(AQUA)),
            Span::styled(format!(" to {what}"), t::text()),
        ]),
        Line::from(""),
        Line::styled(format!("  {cost}"), t::muted()),
    ])
}

fn heading(s: &str) -> Line<'static> {
    Line::styled(s.to_string(), t::heading())
}

pub fn draw(f: &mut Frame, app: &mut App) {
    // tab bar, a blank line, the tab's content, then the key panel
    let [top, _, body, keys] = Layout::vertical([
        Constraint::Length(1),
        Constraint::Length(1),
        Constraint::Min(0),
        Constraint::Length(5),
    ])
    .areas(f.area());

    // tabs centred across the whole width; the nx badge sits on the left
    let mut spans = vec![];
    for (i, tab) in Tab::ALL.iter().enumerate() {
        if i > 0 {
            spans.push(Span::styled("   ", Style::new()));
        }
        let label = format!(" {} {} ", i + 1, tab.title());
        let style = if *tab == app.tab {
            t::key(YELLOW)
        } else {
            Style::new().fg(FG4)
        };
        spans.push(Span::styled(label, style));
    }
    f.render_widget(Line::from(spans).centered(), top);
    f.render_widget(Span::styled(" nx ", t::key(AQUA)), top);

    if let Some(job) = &app.job {
        job_view(f, job, body);
    } else {
        match app.tab {
            Tab::Status => status(f, app, body),
            Tab::Apps => apps(f, app, body),
            Tab::Storage => storage(f, app, body),
            Tab::Doctor => doctor(f, app, body),
            Tab::Generations => generations(f, app, body),
            Tab::Code => code(f, app, body),
        }
    }

    key_panel(f, app, keys);
    if let Some(action) = &app.confirm {
        confirm(f, &action.label, &action.args.join(" "));
    }
}

/// Two rows of key badges: moving around (and this tab's keys), then actions.
fn key_panel(f: &mut Frame, app: &App, area: Rect) {
    fn badges(label: &'static str, keys: &[(&'static str, &'static str, Color)]) -> Line<'static> {
        let mut spans = vec![Span::styled(format!(" {label:<5}"), t::muted())];
        for (k, what, colour) in keys {
            spans.push(Span::styled(format!(" {k} "), t::key(*colour)));
            spans.push(Span::styled(format!(" {what}  "), t::text()));
        }
        Line::from(spans)
    }
    let (first, second): (Line, Line) = if let Some(job) = &app.job {
        let running = job.finished.is_none();
        (
            badges(
                "View",
                &[
                    ("↑↓", "scroll", BLUE),
                    ("PgUp/PgDn", "page", BLUE),
                    ("End", "follow", BLUE),
                ],
            ),
            if running {
                badges("Job", &[("Ctrl+C", "stop it", RED)])
            } else {
                badges("Job", &[("Enter", "back to the tabs", GREEN)])
            },
        )
    } else {
        let mut nav: Vec<(&str, &str, Color)> = vec![
            ("1-6", "tab", BLUE),
            ("←→", "tab", BLUE),
            ("r", "reload", BLUE),
            ("q", "quit", BLUE),
        ];
        let tab: &[(&str, &str, Color)] = match app.tab {
            Tab::Apps if app.filtering => &[("Enter", "keep filter", AQUA), ("Esc", "clear", AQUA)],
            Tab::Apps if app.heavy_waiting() => &[("Enter", "measure", AQUA)],
            Tab::Apps => &[
                ("/", "filter", AQUA),
                ("s", "sort", AQUA),
                ("a", "small ones", AQUA),
            ],
            Tab::Storage if app.heavy_waiting() => &[("Enter", "measure", AQUA)],
            Tab::Storage => &[("X", "clean caches", ORANGE)],
            Tab::Generations => &[("←→", "nixos/home", AQUA), ("Enter", "roll back", ORANGE)],
            _ => &[],
        };
        nav.extend_from_slice(tab);
        (
            badges("Move", &nav),
            badges(
                "Run",
                &[
                    ("U", "update", YELLOW),
                    ("B", "build", YELLOW),
                    ("S", "switch", YELLOW),
                    ("T", "test", YELLOW),
                    ("H", "home", YELLOW),
                    ("A", "all", YELLOW),
                    ("C", "clean", ORANGE),
                    ("D", "diff", YELLOW),
                ],
            ),
        )
    };
    let mut b = Block::bordered()
        .border_type(BorderType::Rounded)
        .border_style(Style::new().fg(BG2))
        .padding(ratatui::widgets::Padding::horizontal(1));
    if let Some(m) = &app.message {
        b = b.title(Span::styled(format!(" {m} "), t::warn()));
    }
    f.render_widget(
        Paragraph::new(vec![first, Line::from(""), second]).block(b),
        area,
    );
}

fn confirm(f: &mut Frame, label: &str, command: &str) {
    let area = f.area();
    let w = (label.len().max(command.len()) as u16 + 8).clamp(44, area.width.saturating_sub(4));
    let rect = Rect::new(
        area.width.saturating_sub(w) / 2,
        (area.height / 2).saturating_sub(3),
        w,
        6,
    );
    f.render_widget(Clear, rect);
    let text = vec![
        Line::styled(label.to_string(), Style::new().fg(FG).bold()),
        Line::styled(format!("runs: nx {command}"), t::muted()),
        Line::from(""),
        Line::from(vec![
            Span::styled(" y ", t::key(GREEN)),
            Span::styled(" / ", t::muted()),
            Span::styled(" Enter ", t::key(GREEN)),
            Span::styled(" go    ", t::text()),
            Span::styled(" any other key ", t::key(RED)),
            Span::styled(" cancel", t::text()),
        ]),
    ];
    f.render_widget(
        Paragraph::new(text)
            .style(Style::new().bg(BG1))
            .block(block("Run?").border_style(Style::new().fg(YELLOW))),
        rect,
    );
}

fn status(f: &mut Frame, app: &App, area: Rect) {
    let b = block("Status");
    if let Some(p) = pending(&app.status, "reading…") {
        return f.render_widget(p.block(b), area);
    }
    let Load::Ready(s) = &app.status else { return };
    let mut lines = vec![heading("Flakes")];
    for l in &s.locks {
        let col = match l.days {
            30.. => RED,
            7.. => YELLOW,
            _ => GREEN,
        };
        lines.push(Line::from(vec![
            Span::styled(format!("  {:<4}", l.name), Style::new().fg(BLUE).bold()),
            Span::styled(" lock ", t::muted()),
            Span::styled(format!("{} days old", l.days), Style::new().fg(col).bold()),
            Span::styled(format!("  {}", l.changed), t::muted()),
            Span::styled("   nixpkgs ", t::muted()),
            Span::styled(l.nixpkgs.clone(), Style::new().fg(PURPLE)),
        ]));
    }
    lines.push(Line::from(""));
    lines.push(heading("Git"));
    for g in &s.git {
        let (mark, rest) = g.split_at(g.len().min(3));
        let col = match mark.trim() {
            "##" => AQUA,
            "M" | "MM" | "AM" => YELLOW,
            "A" => GREEN,
            "D" => RED,
            "??" => ORANGE,
            _ => FG4,
        };
        lines.push(Line::from(vec![
            Span::styled(format!("  {mark}"), Style::new().fg(col).bold()),
            Span::styled(rest.to_string(), t::text()),
        ]));
    }
    if s.git.len() == 1 {
        lines.push(Line::styled("  clean", t::good()));
    }
    lines.push(Line::from(""));
    lines.push(heading("Disk"));
    let col = match s.disk_percent {
        90.. => RED,
        75.. => YELLOW,
        _ => GREEN,
    };
    if let Some(d) = s.disk.get(1) {
        let f2: Vec<&str> = d.split_whitespace().collect();
        if f2.len() >= 5 {
            lines.push(Line::from(vec![
                Span::styled(format!("  {}", f2[0]), t::muted()),
                Span::styled(format!("   {} used", f2[2]), Style::new().fg(col).bold()),
                Span::styled(format!(" of {}", f2[1]), t::text()),
                Span::styled(format!("   {} free", f2[3]), Style::new().fg(AQUA)),
            ]));
        }
    }
    // how full / is, as a fixed-width bar right under the numbers
    const BAR: usize = 40;
    let filled = (usize::from(s.disk_percent) * BAR / 100).min(BAR);
    lines.push(Line::from(vec![
        Span::styled("  ", t::text()),
        Span::styled("━".repeat(filled), Style::new().fg(col)),
        Span::styled("━".repeat(BAR - filled), Style::new().fg(BG2)),
        Span::styled(
            format!(" {}% full", s.disk_percent),
            Style::new().fg(col).bold(),
        ),
    ]));
    f.render_widget(Paragraph::new(lines).block(b), area);
}

fn apps(f: &mut Frame, app: &mut App, area: Rect) {
    let sort = match app.sort {
        SortBy::Unique => "unique size",
        SortBy::Closure => "closure",
        SortBy::Name => "name",
    };
    let filter = if app.filtering || !app.filter.is_empty() {
        format!(
            " · filter: {}{}",
            app.filter,
            if app.filtering { "▏" } else { "" }
        )
    } else {
        String::new()
    };
    let small = if app.show_small {
        "all sizes"
    } else {
        "small hidden"
    };
    let b = block("Apps").title_bottom(Line::styled(
        format!(" sorted by {sort} · {small}{filter} "),
        t::muted(),
    ));
    if app.heavy_waiting() && !matches!(app.apps, Load::Failed(_)) {
        let p = press_enter(
            "measure installed apps",
            "Walks every package's closure to find what only it uses; takes a second or two.",
        );
        return f.render_widget(p.block(b), area);
    }
    if let Some(p) = pending(&app.apps, "measuring closures…") {
        return f.render_widget(p.block(b), area);
    }
    let visible = app.visible_apps();
    let total: u64 = visible.iter().map(|a| a.unique).sum();
    let count = visible.len();
    let rows: Vec<Row> = visible
        .into_iter()
        .map(|a| {
            let c = class_colour(a.class());
            let origin = match a.origin() {
                "home" => BLUE,
                "system" => PURPLE,
                _ => AQUA,
            };
            Row::new(vec![
                Cell::from(Span::styled(a.class().name(), Style::new().fg(c).bold())),
                Cell::from(
                    Line::styled(human_binary(a.unique), Style::new().fg(c)).right_aligned(),
                ),
                Cell::from(Line::styled(human_binary(a.closure), t::muted()).right_aligned()),
                Cell::from(Span::styled(a.name.clone(), t::text())),
                Cell::from(Span::styled(a.origin(), Style::new().fg(origin))),
            ])
        })
        .collect();
    let table = Table::new(
        rows,
        [
            Constraint::Length(7),
            Constraint::Length(10),
            Constraint::Length(10),
            Constraint::Min(20),
            Constraint::Length(12),
        ],
    )
    .header(
        Row::new(vec!["class", "     size", "  closure", "name", "from"])
            .style(Style::new().fg(AQUA).bold()),
    )
    .row_highlight_style(t::selected())
    .highlight_symbol(Span::styled("▶ ", Style::new().fg(YELLOW)))
    .block(
        b.title_top(
            Line::from(vec![
                Span::styled(format!(" {count} apps · "), t::muted()),
                Span::styled(human_binary(total), t::number()),
                Span::styled(" only theirs ", t::muted()),
            ])
            .right_aligned(),
        ),
    );
    f.render_stateful_widget(table, area, &mut app.apps_table);
}

fn storage(f: &mut Frame, app: &App, area: Rect) {
    let b = block("Storage");
    if app.heavy_waiting() && !matches!(app.storage, Load::Failed(_)) {
        let p = press_enter(
            "measure caches and big folders",
            "Sizes every cache and folder with du, /nix/store included; that one can take a while.",
        );
        return f.render_widget(p.block(b), area);
    }
    if let Some(p) = pending(
        &app.storage,
        "measuring folders… (/nix/store takes a while)",
    ) {
        return f.render_widget(p.block(b), area);
    }
    let Load::Ready(r) = &app.storage else { return };
    let row = |path: &std::path::Path, bytes: u64| {
        Line::from(vec![
            Span::styled(
                format!("  {:>8}  ", human(bytes)),
                Style::new().fg(t::size(bytes)).bold(),
            ),
            Span::styled(path.display().to_string(), t::text()),
        ])
    };
    let mut lines = vec![
        heading("Disk"),
        Line::styled(format!("  {}", r.disk), t::text()),
        Line::from(""),
        heading("Safe to delete (regenerable caches · X cleans)"),
    ];
    lines.extend(r.caches.iter().map(|(p, s)| row(p, *s)));
    let total: u64 = r.caches.iter().map(|(_, s)| s).sum();
    lines.push(Line::from(vec![
        Span::styled(format!("  {:>8}  ", human(total)), t::number().bold()),
        Span::styled("total", Style::new().fg(FG).bold()),
    ]));
    lines.push(Line::from(""));
    lines.push(heading("Also cleaned"));
    lines.push(Line::from(vec![
        Span::styled("  journal  ", Style::new().fg(BLUE)),
        Span::styled(format!("{} → vacuum to 200M", r.journal), t::text()),
    ]));
    if let Some(n) = r.flatpak_unused {
        lines.push(Line::from(vec![
            Span::styled("  flatpak  ", Style::new().fg(BLUE)),
            Span::styled(format!("{n} unused runtime(s)"), t::text()),
        ]));
    }
    if r.docker {
        lines.push(Line::from(vec![
            Span::styled("  docker   ", Style::new().fg(BLUE)),
            Span::styled("stopped containers + dangling images", t::text()),
        ]));
    }
    lines.push(Line::from(""));
    lines.push(heading("Big, but yours (never touched)"));
    lines.extend(r.yours.iter().map(|(p, s)| row(p, *s)));
    f.render_widget(Paragraph::new(lines).block(b), area);
}

fn doctor(f: &mut Frame, app: &App, area: Rect) {
    let b = block("Doctor");
    if let Some(p) = pending(&app.doctor, "checking…") {
        return f.render_widget(p.block(b), area);
    }
    let Load::Ready(checks) = &app.doctor else {
        return;
    };
    let mut lines = vec![];
    let mut section = "";
    for c in checks {
        if c.section != section {
            section = c.section;
            if !lines.is_empty() {
                lines.push(Line::from(""));
            }
            lines.push(heading(section));
        }
        let (mark, style) = if c.ok {
            ("✔", t::good())
        } else {
            ("!", t::warn())
        };
        lines.push(Line::from(vec![
            Span::styled(format!("  {mark} "), style),
            Span::styled(
                c.message.clone(),
                if c.ok {
                    t::text()
                } else {
                    Style::new().fg(YELLOW)
                },
            ),
        ]));
    }
    let issues = checks.iter().filter(|c| !c.ok).count();
    let summary = if issues == 0 {
        Span::styled(" all good ", t::good())
    } else {
        Span::styled(format!(" {issues} thing(s) to look at "), t::warn())
    };
    f.render_widget(
        Paragraph::new(lines)
            .wrap(Wrap { trim: false })
            .block(b.title_bottom(Line::from(summary))),
        area,
    );
}

fn generations(f: &mut Frame, app: &mut App, area: Rect) {
    let [left, right] =
        Layout::horizontal([Constraint::Percentage(50), Constraint::Percentage(50)]).areas(area);
    if let Some(p) = pending(&app.generations, "reading…") {
        return f.render_widget(p.block(block("Generations")), area);
    }
    let Load::Ready((os, home)) = &app.generations else {
        return;
    };
    let items = |gens: &[crate::cmd::rollback::Generation]| -> Vec<ListItem<'static>> {
        gens.iter()
            .map(|g| {
                let mut spans = vec![
                    Span::styled(format!("{:>5}  ", g.id), t::number().bold()),
                    Span::styled(g.date.clone(), t::text()),
                ];
                if g.current {
                    spans.push(Span::styled("  ● current", t::good()));
                }
                ListItem::new(Line::from(spans))
            })
            .collect()
    };
    let border = |active: bool| Style::new().fg(if active { YELLOW } else { BG2 });
    let os_list = List::new(items(os))
        .block(block("NixOS").border_style(border(!app.gens_home)))
        .highlight_style(t::selected())
        .highlight_symbol(Span::styled("▶ ", Style::new().fg(YELLOW)));
    let home_list = List::new(items(home))
        .block(block("Home").border_style(border(app.gens_home)))
        .highlight_style(t::selected())
        .highlight_symbol(Span::styled("▶ ", Style::new().fg(YELLOW)));
    let mut idle = ratatui::widgets::ListState::default();
    if app.gens_home {
        f.render_stateful_widget(os_list, left, &mut idle);
        f.render_stateful_widget(home_list, right, &mut app.gens_list);
    } else {
        f.render_stateful_widget(os_list, left, &mut app.gens_list);
        f.render_stateful_widget(home_list, right, &mut idle);
    }
}

fn code(f: &mut Frame, app: &App, area: Rect) {
    let b = block("Lines of code");
    if let Some(p) = pending(&app.code, "counting…") {
        return f.render_widget(p.block(b), area);
    }
    let Load::Ready(groups) = &app.code else {
        return;
    };
    let num =
        |n: usize, style: Style| Cell::from(Line::styled(n.to_string(), style).right_aligned());
    let mut rows = vec![];
    let mut grand = crate::cmd::loc::Count::default();
    for (i, g) in groups.iter().enumerate() {
        if i > 0 {
            rows.push(Row::new(vec![Cell::from("")]));
        }
        rows.push(Row::new(vec![Cell::from(Line::styled(
            g.name,
            t::heading(),
        ))]));
        for c in &g.categories {
            rows.push(Row::new(vec![
                Cell::from(Span::styled(format!("  {}", c.name), t::text())),
                num(c.count.files, t::muted()),
                num(c.count.code, Style::new().fg(BLUE)),
                num(c.count.comments, Style::new().fg(GRAY)),
                num(c.count.total(), t::number()),
            ]));
        }
        let tot = g.total();
        let bold = Style::new().bold();
        rows.push(Row::new(vec![
            Cell::from(Span::styled(
                format!("  {} total", g.name),
                Style::new().fg(YELLOW).bold(),
            )),
            num(tot.files, bold.fg(FG4)),
            num(tot.code, bold.fg(BLUE)),
            num(tot.comments, bold.fg(GRAY)),
            num(tot.total(), bold.fg(ORANGE)),
        ]));
        grand.files += tot.files;
        grand.code += tot.code;
        grand.comments += tot.comments;
    }
    let summary = Line::from(vec![
        Span::styled(" ", t::text()),
        Span::styled(grand.total().to_string(), t::number().bold()),
        Span::styled(format!(" lines in {} files (", grand.files), t::text()),
        Span::styled(format!("{} code", grand.code), Style::new().fg(BLUE)),
        Span::styled(", ", t::text()),
        Span::styled(
            format!("{} comments", grand.comments),
            Style::new().fg(GRAY),
        ),
        Span::styled(") ", t::text()),
    ]);
    let table = Table::new(
        rows,
        [
            Constraint::Min(34),
            Constraint::Length(7),
            Constraint::Length(8),
            Constraint::Length(10),
            Constraint::Length(8),
        ],
    )
    .header(
        Row::new(vec!["", "  files", "    code", "  comments", "   total"])
            .style(Style::new().fg(AQUA).bold()),
    )
    .block(
        b.title_bottom(summary).title_bottom(
            Line::styled(
                " no blanks, locks, assets, secrets, generated or docs ",
                t::muted(),
            )
            .right_aligned(),
        ),
    );
    f.render_widget(table, area);
}

/// A running (or finished) action: output on top, system stats below.
fn job_view(f: &mut Frame, job: &Job, area: Rect) {
    let [out_area, stats_area] =
        Layout::vertical([Constraint::Min(5), Constraint::Length(8)]).areas(area);

    let elapsed = job.elapsed().as_secs();
    let elapsed = format!("{}:{:02}", elapsed / 60, elapsed % 60);
    let (state, style) = match job.finished {
        None => ("running", Style::new().fg(BG1).bg(YELLOW).bold()),
        Some((true, _)) => ("done", t::key(GREEN)),
        Some((false, _)) => ("failed", t::key(RED)),
    };
    let b = block(&job.label)
        .border_style(Style::new().fg(match job.finished {
            None => YELLOW,
            Some((true, _)) => GREEN,
            Some((false, _)) => RED,
        }))
        .title_top(
            Line::from(vec![
                Span::styled(format!(" {} ", job.command), t::muted()),
                Span::styled(format!(" {state} "), style),
                Span::styled(format!(" {elapsed} "), t::number()),
            ])
            .right_aligned(),
        );
    let inner = b.inner(out_area);
    f.render_widget(b, out_area);
    let height = inner.height as usize;
    let lines: Vec<Line> = job
        .screen
        .lock()
        .map(|s| {
            let end = job.scroll.unwrap_or(s.lines.len()).min(s.lines.len());
            let start = end.saturating_sub(height);
            s.lines[start..end].iter().map(|l| output_line(l)).collect()
        })
        .unwrap_or_default();
    f.render_widget(Paragraph::new(lines), inner);

    stats(f, job, stats_area);
}

/// Colour nh / nvd / nx output lines by what they are.
fn output_line(l: &str) -> Line<'static> {
    let lower = l.to_lowercase();
    let trimmed = l.trim_start();
    if let Some(rest) = trimmed.strip_prefix("> ") {
        return Line::from(vec![
            Span::styled("> ", Style::new().fg(GREEN).bold()),
            Span::styled(rest.to_string(), Style::new().fg(FG).bold()),
        ]);
    }
    let style = if lower.contains("error") || trimmed.starts_with("✖") {
        Style::new().fg(RED).bold()
    } else if lower.starts_with("warning") || trimmed.starts_with('!') {
        Style::new().fg(YELLOW)
    } else if trimmed.starts_with("[A") || trimmed.starts_with("[U") {
        Style::new().fg(GREEN)
    } else if trimmed.starts_with("[R") || trimmed.starts_with("[D") {
        Style::new().fg(RED)
    } else if [
        "ADDED", "REMOVED", "CHANGED", "PATHS", "SIZE", "DIFF", "VERSION", "<<<", ">>>",
    ]
    .iter()
    .any(|w| trimmed.starts_with(w))
    {
        Style::new().fg(AQUA).bold()
    } else if trimmed.starts_with(['┃', '┏', '┗', '┣', '│', '├', '└', '┌']) {
        Style::new().fg(FG4)
    } else if trimmed.starts_with('✔') || lower.starts_with("done") {
        Style::new().fg(GREEN)
    } else {
        Style::new().fg(FG)
    };
    Line::styled(l.to_string(), style)
}

fn stats(f: &mut Frame, job: &Job, area: Rect) {
    let b = block("System");
    let inner = b.inner(area);
    f.render_widget(b, area);
    let [net, side] =
        Layout::horizontal([Constraint::Percentage(62), Constraint::Percentage(38)]).areas(inner);
    let [down_label, down, up_label, up] = Layout::vertical([
        Constraint::Length(1),
        Constraint::Length(2),
        Constraint::Length(1),
        Constraint::Length(2),
    ])
    .areas(net);
    let rate = |q: &std::collections::VecDeque<u64>| q.back().copied().unwrap_or(0);
    let (rx, tx) = job.stats.totals();
    let label = |name: &str, colour: Color, now: u64, total: u64| {
        Line::from(vec![
            Span::styled(format!(" {name} "), Style::new().fg(colour).bold()),
            Span::styled(format!("{}/s", human(now)), Style::new().fg(FG).bold()),
            Span::styled(format!("   {} this run", human(total)), t::muted()),
        ])
    };
    let width = down.width as usize;
    let tail = |q: &std::collections::VecDeque<u64>| -> Vec<u64> {
        q.iter()
            .skip(q.len().saturating_sub(width))
            .copied()
            .collect()
    };
    f.render_widget(label("↓ down", AQUA, rate(&job.stats.down), rx), down_label);
    f.render_widget(
        Sparkline::default()
            .data(tail(&job.stats.down))
            .style(Style::new().fg(AQUA)),
        down,
    );
    f.render_widget(label("↑ up  ", PURPLE, rate(&job.stats.up), tx), up_label);
    f.render_widget(
        Sparkline::default()
            .data(tail(&job.stats.up))
            .style(Style::new().fg(PURPLE)),
        up,
    );

    let [cpu_label, cpu, mem_label, mem, load] = Layout::vertical([
        Constraint::Length(1),
        Constraint::Length(1),
        Constraint::Length(1),
        Constraint::Length(1),
        Constraint::Length(2),
    ])
    .areas(side);
    let gauge = |ratio: f64, colour: Color| {
        LineGauge::default()
            .filled_style(Style::new().fg(colour))
            .unfilled_style(Style::new().fg(BG2))
            .filled_symbol(symbols::line::THICK_HORIZONTAL)
            .unfilled_symbol(symbols::line::THICK_HORIZONTAL)
            .label("")
            .ratio(ratio.clamp(0.0, 1.0))
    };
    let s = &job.stats;
    let cpu_col = match s.cpu_percent {
        p if p >= 85.0 => RED,
        p if p >= 50.0 => YELLOW,
        _ => GREEN,
    };
    f.render_widget(
        Line::from(vec![
            Span::styled(" cpu ", Style::new().fg(BLUE).bold()),
            Span::styled(format!("{:.0}%", s.cpu_percent), Style::new().fg(FG).bold()),
        ]),
        cpu_label,
    );
    f.render_widget(
        gauge(s.cpu_percent / 100.0, cpu_col),
        cpu.inner(ratatui::layout::Margin::new(1, 0)),
    );
    let mem_ratio = if s.mem_total > 0 {
        s.mem_used as f64 / s.mem_total as f64
    } else {
        0.0
    };
    f.render_widget(
        Line::from(vec![
            Span::styled(" mem ", Style::new().fg(BLUE).bold()),
            Span::styled(human(s.mem_used), Style::new().fg(FG).bold()),
            Span::styled(format!(" of {}", human(s.mem_total)), t::muted()),
        ]),
        mem_label,
    );
    f.render_widget(
        gauge(mem_ratio, if mem_ratio > 0.85 { RED } else { PURPLE }),
        mem.inner(ratatui::layout::Margin::new(1, 0)),
    );
    f.render_widget(
        Line::from(vec![
            Span::styled(" load ", Style::new().fg(BLUE).bold()),
            Span::styled(s.load.clone(), t::text()),
        ]),
        load,
    );
}
