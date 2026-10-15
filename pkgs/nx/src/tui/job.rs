//! Running `nx <command>` inside the TUI: its output goes to a pane, with live system
//! stats (network, CPU, memory) underneath.
//!
//! nh draws a live build tree (nix-output-monitor) by moving the cursor up and erasing
//! lines. Logging that raw would repeat the tree on every redraw, so the output is fed
//! through a tiny screen model that understands the few escape codes nom uses.

use anyhow::{Context, Result};
use ratatui::style::{Color, Modifier, Style};
use std::collections::VecDeque;
use std::io::Read;
use std::path::PathBuf;
use std::process::{Child, Command, Stdio};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

const MAX_LINES: usize = 5000;

/// One line of output: each character with the colours it was printed in.
pub type Cells = Vec<(char, Style)>;

pub fn text(line: &Cells) -> String {
    line.iter().map(|(c, _)| c).collect()
}

/// Output lines with a cursor, enough for `\r`, cursor moves, erase-line and colours.
#[derive(Default)]
pub struct Screen {
    pub lines: Vec<Cells>,
    row: usize,
    col: usize,
    style: Style,
    /// after `\r` or a move onto another line, the next text replaces the rest of the
    /// line instead of leaving the old tail behind
    overwrite: bool,
    /// an escape sequence cut off at the end of the last read, finished by the next one
    partial: String,
}

impl Screen {
    fn current(&mut self) -> &mut Cells {
        while self.lines.len() <= self.row {
            self.lines.push(Vec::new());
        }
        &mut self.lines[self.row]
    }

    fn put(&mut self, c: char) {
        let (col, style, overwrite) = (self.col, self.style, self.overwrite);
        self.overwrite = false;
        let line = self.current();
        if overwrite {
            line.truncate(col);
        }
        while line.len() < col {
            line.push((' ', Style::default()));
        }
        if col < line.len() {
            line[col] = (c, style);
        } else {
            line.push((c, style));
        }
        self.col += 1;
    }

    fn newline(&mut self) {
        self.current();
        self.row += 1;
        self.col = 0;
        // moving down onto a line that's already there (after a cursor-up) writes over it
        self.overwrite = self.row < self.lines.len();
        if self.lines.len() > MAX_LINES {
            let cut = self.lines.len() - MAX_LINES;
            self.lines.drain(..cut);
            self.row = self.row.saturating_sub(cut);
        }
    }

    fn up(&mut self, n: usize) {
        self.row = self.row.saturating_sub(n);
        self.overwrite = true;
    }

    /// Feed decoded output; an escape sequence may be split across calls.
    pub fn feed(&mut self, text: &str) {
        let mut buf = std::mem::take(&mut self.partial) + text;
        if let Some(i) = buf.rfind('\x1b').filter(|&i| !complete(&buf[i..])) {
            self.partial = buf.split_off(i);
        }
        let mut chars = buf.chars().peekable();
        while let Some(c) = chars.next() {
            match c {
                '\n' => self.newline(),
                '\r' => {
                    self.col = 0;
                    self.overwrite = true;
                }
                '\x08' => self.col = self.col.saturating_sub(1),
                '\x1b' => match chars.next() {
                    // CSI: parameters, then one final byte
                    Some('[') => {
                        let mut params = String::new();
                        let mut fin = ' ';
                        for p in chars.by_ref() {
                            if ('@'..='~').contains(&p) {
                                fin = p;
                                break;
                            }
                            params.push(p);
                        }
                        let n = || {
                            params
                                .trim_start_matches('?')
                                .parse::<usize>()
                                .unwrap_or(1)
                                .max(1)
                        };
                        match fin {
                            'm' => self.style = sgr(self.style, &params),
                            'A' => self.up(n()),
                            // previous line
                            'F' => {
                                self.up(n());
                                self.col = 0;
                            }
                            'B' | 'E' => {
                                for _ in 0..n() {
                                    self.newline();
                                }
                            }
                            'C' => self.col += n(),
                            'D' => self.col = self.col.saturating_sub(n()),
                            'G' => self.col = n() - 1,
                            'K' => {
                                let col = self.col;
                                let line = self.current();
                                match params.as_str() {
                                    // to the start: blank it, the text after stays put
                                    "1" => line
                                        .iter_mut()
                                        .take(col + 1)
                                        .for_each(|c| *c = (' ', Style::default())),
                                    "2" => line.clear(),
                                    _ => line.truncate(col),
                                }
                            }
                            // erase below
                            'J' if params.is_empty() || params == "0" => {
                                let col = self.col;
                                self.lines.truncate(self.row + 1);
                                self.current().truncate(col);
                            }
                            _ => {} // sync updates, cursor visibility, clear screen…
                        }
                    }
                    // OSC: up to BEL or ESC \
                    Some(']') => {
                        while let Some(p) = chars.next() {
                            if p == '\x07' || (p == '\x1b' && chars.next_if_eq(&'\\').is_some()) {
                                break;
                            }
                        }
                    }
                    _ => {}
                },
                '\t' => {
                    for _ in 0..4 - self.col % 4 {
                        self.put(' ');
                    }
                }
                c if c.is_control() => {}
                c => self.put(c),
            }
        }
    }
}

/// Does `s` (starting at an ESC) hold the whole escape sequence?
fn complete(s: &str) -> bool {
    let mut rest = s.chars().skip(1);
    match rest.next() {
        None => false,
        Some('[') => rest.any(|c| ('@'..='~').contains(&c)),
        Some(']') => s.contains('\x07') || s[1..].contains("\x1b\\"),
        Some(_) => true,
    }
}

/// Apply one `ESC [ … m` (select graphic rendition) to the current style.
fn sgr(mut style: Style, params: &str) -> Style {
    let mut nums = params
        .split([';', ':'])
        .map(|p| p.parse::<u16>().unwrap_or(0));
    // `ESC [ m` means reset, like `ESC [ 0 m`
    if params.is_empty() {
        return Style::default();
    }
    while let Some(n) = nums.next() {
        let mut extended = || -> Option<Color> {
            match nums.next()? {
                5 => Some(Color::Indexed(nums.next()? as u8)),
                2 => Some(Color::Rgb(
                    nums.next()? as u8,
                    nums.next()? as u8,
                    nums.next()? as u8,
                )),
                _ => None,
            }
        };
        style = match n {
            0 => Style::default(),
            1 => style.add_modifier(Modifier::BOLD),
            2 => style.add_modifier(Modifier::DIM),
            3 => style.add_modifier(Modifier::ITALIC),
            4 => style.add_modifier(Modifier::UNDERLINED),
            7 => style.add_modifier(Modifier::REVERSED),
            9 => style.add_modifier(Modifier::CROSSED_OUT),
            22 => style.remove_modifier(Modifier::BOLD | Modifier::DIM),
            23 => style.remove_modifier(Modifier::ITALIC),
            24 => style.remove_modifier(Modifier::UNDERLINED),
            27 => style.remove_modifier(Modifier::REVERSED),
            29 => style.remove_modifier(Modifier::CROSSED_OUT),
            30..=37 => style.fg(Color::Indexed(n as u8 - 30)),
            90..=97 => style.fg(Color::Indexed(n as u8 - 90 + 8)),
            40..=47 => style.bg(Color::Indexed(n as u8 - 40)),
            100..=107 => style.bg(Color::Indexed(n as u8 - 100 + 8)),
            38 => match extended() {
                Some(c) => style.fg(c),
                None => style,
            },
            48 => match extended() {
                Some(c) => style.bg(c),
                None => style,
            },
            39 => Style { fg: None, ..style },
            49 => Style { bg: None, ..style },
            _ => style,
        };
    }
    style
}

pub struct Job {
    pub label: String,
    pub command: String,
    pub screen: Arc<Mutex<Screen>>,
    child: Child,
    pub started: Instant,
    /// Some(success) once it has exited
    pub finished: Option<(bool, Duration)>,
    /// None = follow the end; Some(n) = scrolled to line n
    pub scroll: Option<usize>,
    /// rows the output pane showed last frame; scrolling up stops once the first line
    /// is at the top
    pub height: std::cell::Cell<usize>,
    pub stats: Stats,
    /// how long the same command took last time it succeeded
    pub previous: Option<Duration>,
    timing: PathBuf,
}

impl Job {
    /// `cache` holds a small file per command with how long it last took.
    pub fn start(label: &str, args: &[String], cache: &std::path::Path) -> Result<Job> {
        let exe = std::env::current_exe().unwrap_or_else(|_| "nx".into());
        // one pipe for stdout and stderr, so the order is kept
        let (mut reader, writer) = std::io::pipe().context("creating a pipe")?;
        let child = Command::new(exe)
            .args(args)
            .stdin(Stdio::null())
            // nx's own steps keep their colours in the pane (see ui.rs)
            .env("NX_COLOR", "1")
            .stdout(writer.try_clone()?)
            .stderr(writer)
            .spawn()
            .context("starting nx")?;
        let screen = Arc::new(Mutex::new(Screen::default()));
        let sink = Arc::clone(&screen);
        std::thread::spawn(move || {
            let mut buf = [0u8; 8192];
            // bytes of a character cut off at the end of the last read
            let mut carry: Vec<u8> = vec![];
            // the pipe closes when the child (and anything it started) exits
            while let Ok(n) = reader.read(&mut buf) {
                if n == 0 {
                    break;
                }
                carry.extend_from_slice(&buf[..n]);
                let keep = match std::str::from_utf8(&carry) {
                    Err(e) if e.error_len().is_none() => carry.len() - e.valid_up_to(),
                    _ => 0,
                };
                let tail = carry.split_off(carry.len() - keep);
                if let Ok(mut s) = sink.lock() {
                    s.feed(&String::from_utf8_lossy(&carry));
                }
                carry = tail;
            }
        });
        let timing = cache.join(format!("took-{}", args.join("-")));
        let previous = std::fs::read_to_string(&timing)
            .ok()
            .and_then(|s| s.trim().parse().ok())
            .map(Duration::from_secs);
        Ok(Job {
            label: label.to_string(),
            command: format!("nx {}", args.join(" ")),
            screen,
            child,
            started: Instant::now(),
            finished: None,
            scroll: None,
            height: std::cell::Cell::new(0),
            stats: Stats::new(),
            previous,
            timing,
        })
    }

    /// Check for exit and refresh the stats; call every tick.
    pub fn poll(&mut self) {
        if self.finished.is_none()
            && let Ok(Some(status)) = self.child.try_wait()
        {
            let took = self.started.elapsed();
            self.finished = Some((status.success(), took));
            if status.success() {
                let _ = std::fs::write(&self.timing, took.as_secs().to_string());
            }
        }
        if self.finished.is_none() {
            self.stats.update();
        }
    }

    pub fn stop(&mut self) {
        let _ = self.child.kill();
    }

    pub fn elapsed(&self) -> Duration {
        self.finished
            .map_or_else(|| self.started.elapsed(), |(_, d)| d)
    }
}

/// System numbers from /proc, sampled about once a second.
pub struct Stats {
    last: Instant,
    net: (u64, u64),
    net_start: (u64, u64),
    cpu: (u64, u64),
    /// bytes per second, newest last
    pub down: VecDeque<u64>,
    pub up: VecDeque<u64>,
    pub cpu_percent: f64,
    pub mem_used: u64,
    pub mem_total: u64,
    pub load: String,
    /// free and total bytes on the filesystem holding /nix/store
    pub store_free: u64,
    pub store_total: u64,
}

const HISTORY: usize = 120;

impl Stats {
    fn new() -> Stats {
        let net = net_bytes();
        let mut s = Stats {
            last: Instant::now(),
            net,
            net_start: net,
            cpu: cpu_ticks(),
            down: VecDeque::from(vec![0; HISTORY]),
            up: VecDeque::from(vec![0; HISTORY]),
            cpu_percent: 0.0,
            mem_used: 0,
            mem_total: 0,
            load: String::new(),
            store_free: 0,
            store_total: 0,
        };
        s.read_mem();
        s
    }

    fn update(&mut self) {
        let dt = self.last.elapsed().as_secs_f64();
        if dt < 1.0 {
            return;
        }
        self.last = Instant::now();
        let net = net_bytes();
        let rate = |now: u64, before: u64| (now.saturating_sub(before) as f64 / dt) as u64;
        push(&mut self.down, rate(net.0, self.net.0));
        push(&mut self.up, rate(net.1, self.net.1));
        self.net = net;
        let cpu = cpu_ticks();
        let (busy, total) = (
            cpu.0.saturating_sub(self.cpu.0),
            cpu.1.saturating_sub(self.cpu.1),
        );
        self.cpu_percent = if total > 0 {
            busy as f64 * 100.0 / total as f64
        } else {
            0.0
        };
        self.cpu = cpu;
        self.read_mem();
    }

    fn read_mem(&mut self) {
        let info = std::fs::read_to_string("/proc/meminfo").unwrap_or_default();
        let field = |name: &str| -> u64 {
            info.lines()
                .find(|l| l.starts_with(name))
                .and_then(|l| l.split_whitespace().nth(1))
                .and_then(|v| v.parse::<u64>().ok())
                .unwrap_or(0)
                * 1024
        };
        self.mem_total = field("MemTotal:");
        self.mem_used = self.mem_total.saturating_sub(field("MemAvailable:"));
        self.load = std::fs::read_to_string("/proc/loadavg")
            .unwrap_or_default()
            .split_whitespace()
            .take(3)
            .collect::<Vec<_>>()
            .join(" ");
        (self.store_free, self.store_total) = disk("/nix/store");
    }

    /// Bytes received / sent since the job started.
    pub fn totals(&self) -> (u64, u64) {
        (
            self.net.0.saturating_sub(self.net_start.0),
            self.net.1.saturating_sub(self.net_start.1),
        )
    }
}

fn push(q: &mut VecDeque<u64>, v: u64) {
    q.push_back(v);
    while q.len() > HISTORY {
        q.pop_front();
    }
}

/// Received and sent bytes over all interfaces except loopback.
fn net_bytes() -> (u64, u64) {
    let text = std::fs::read_to_string("/proc/net/dev").unwrap_or_default();
    text.lines()
        .skip(2)
        .filter_map(|l| l.split_once(':'))
        .filter(|(iface, _)| iface.trim() != "lo")
        .fold((0, 0), |(rx, tx), (_, rest)| {
            let f: Vec<u64> = rest
                .split_whitespace()
                .filter_map(|v| v.parse().ok())
                .collect();
            (
                rx + f.first().copied().unwrap_or(0),
                tx + f.get(8).copied().unwrap_or(0),
            )
        })
}

/// (free, total) bytes of the filesystem holding `path`.
fn disk(path: &str) -> (u64, u64) {
    let Ok(c) = std::ffi::CString::new(path) else {
        return (0, 0);
    };
    let mut v: libc::statvfs = unsafe { std::mem::zeroed() };
    if unsafe { libc::statvfs(c.as_ptr(), &mut v) } != 0 {
        return (0, 0);
    }
    let block = v.f_frsize as u64;
    (v.f_bavail as u64 * block, v.f_blocks as u64 * block)
}

/// (busy, total) jiffies from the first line of /proc/stat.
fn cpu_ticks() -> (u64, u64) {
    let text = std::fs::read_to_string("/proc/stat").unwrap_or_default();
    let f: Vec<u64> = text
        .lines()
        .next()
        .unwrap_or_default()
        .split_whitespace()
        .skip(1)
        .filter_map(|v| v.parse().ok())
        .collect();
    let total: u64 = f.iter().take(8).sum();
    let idle = f.get(3).copied().unwrap_or(0) + f.get(4).copied().unwrap_or(0);
    (total.saturating_sub(idle), total)
}

#[cfg(test)]
mod tests {
    use super::{Screen, text};
    use ratatui::style::{Color, Modifier};

    fn screen(input: &str) -> Vec<String> {
        let mut s = Screen::default();
        s.feed(input);
        s.lines.iter().map(text).collect()
    }

    #[test]
    fn plain_lines() {
        assert_eq!(screen("a\nb\n"), ["a", "b"]);
    }

    #[test]
    fn carriage_return_overwrites() {
        assert_eq!(screen("10%\r55%\r100%\n"), ["100%"]);
    }

    #[test]
    fn colours_are_kept() {
        let mut s = Screen::default();
        s.feed("\x1b[1;32m>\x1b[0m done \x1b[48;5;4mbar\x1b[49m\n");
        assert_eq!(text(&s.lines[0]), "> done bar");
        let (gt, done, bar) = (s.lines[0][0].1, s.lines[0][2].1, s.lines[0][7].1);
        assert_eq!(gt.fg, Some(Color::Indexed(2)));
        assert!(gt.add_modifier.contains(Modifier::BOLD));
        assert_eq!(done.fg, None);
        assert_eq!(bar.bg, Some(Color::Indexed(4)));
    }

    #[test]
    fn split_reads() {
        let mut s = Screen::default();
        s.feed("a\x1b[?20");
        s.feed("26hb\x1b");
        s.feed("[32mc\n");
        assert_eq!(text(&s.lines[0]), "abc");
        assert_eq!(s.lines[0][2].1.fg, Some(Color::Indexed(2)));
    }

    #[test]
    fn column_moves() {
        // spinner style: back to column 1, erase, redraw
        assert_eq!(screen("⠋ 0s\x1b[1G\x1b[2K⠙ 1s\n"), ["⠙ 1s"]);
        assert_eq!(screen("abc\x1b[2Dx\n"), ["axc"]);
    }

    #[test]
    fn redrawn_tree_does_not_repeat() {
        // how nom redraws a two-line status: up two lines, erase each, write again
        let frame = |n: u32| format!("building {n}\nstatus\n");
        let mut s = Screen::default();
        s.feed(&frame(1));
        s.feed(&format!("\x1b[2F\x1b[2K{}", frame(2)));
        let lines: Vec<String> = s.lines.iter().map(text).collect();
        assert_eq!(lines, ["building 2", "status"]);
    }

    #[test]
    fn osc_titles_are_skipped() {
        assert_eq!(screen("\x1b]0;title\x07text\n"), ["text"]);
    }
}
