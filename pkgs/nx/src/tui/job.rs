//! Running `nx <command>` inside the TUI: its output goes to a pane, with live system
//! stats (network, CPU, memory) underneath.
//!
//! nh draws a live build tree (nix-output-monitor) by moving the cursor up and erasing
//! lines. Logging that raw would repeat the tree on every redraw, so the output is fed
//! through a tiny screen model that understands the few escape codes nom uses.

use anyhow::{Context, Result};
use std::collections::VecDeque;
use std::io::Read;
use std::process::{Child, Command, Stdio};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

const MAX_LINES: usize = 5000;

/// Output lines with a cursor row, enough for `\r`, cursor-up and erase-line.
#[derive(Default)]
pub struct Screen {
    pub lines: Vec<String>,
    row: usize,
    /// after `\r` or a cursor move, the next text replaces the line instead of extending it
    overwrite: bool,
}

impl Screen {
    fn current(&mut self) -> &mut String {
        while self.lines.len() <= self.row {
            self.lines.push(String::new());
        }
        &mut self.lines[self.row]
    }

    fn put(&mut self, c: char) {
        if self.overwrite {
            self.current().clear();
            self.overwrite = false;
        }
        self.current().push(c);
    }

    fn newline(&mut self) {
        self.current();
        self.row += 1;
        // moving down onto a line that's already there (after a cursor-up) writes over it
        self.overwrite = self.row < self.lines.len();
        if self.lines.len() > MAX_LINES {
            let cut = self.lines.len() - MAX_LINES;
            self.lines.drain(..cut);
            self.row = self.row.saturating_sub(cut);
        }
    }

    /// Feed raw bytes (decoded lossily as UTF-8).
    pub fn feed(&mut self, text: &str) {
        let mut chars = text.chars().peekable();
        while let Some(c) = chars.next() {
            match c {
                '\n' => self.newline(),
                '\r' => self.overwrite = true,
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
                        let n = params
                            .trim_start_matches('?')
                            .parse::<usize>()
                            .unwrap_or(1)
                            .max(1);
                        match fin {
                            // cursor up / previous line
                            'A' | 'F' => {
                                self.row = self.row.saturating_sub(n);
                                self.overwrite = true;
                            }
                            // erase line
                            'K' => {
                                self.current().clear();
                            }
                            // erase below
                            'J' => {
                                self.lines.truncate(self.row + 1);
                                self.current().clear();
                            }
                            _ => {} // colours, sync updates, cursor visibility…
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
                    for _ in 0..4 {
                        self.put(' ');
                    }
                }
                c if c.is_control() => {}
                c => self.put(c),
            }
        }
    }
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
    pub stats: Stats,
}

impl Job {
    pub fn start(label: &str, args: &[String]) -> Result<Job> {
        let exe = std::env::current_exe().unwrap_or_else(|_| "nx".into());
        // one pipe for stdout and stderr, so the order is kept
        let (mut reader, writer) = std::io::pipe().context("creating a pipe")?;
        let child = Command::new(exe)
            .args(args)
            .stdin(Stdio::null())
            .stdout(writer.try_clone()?)
            .stderr(writer)
            .spawn()
            .context("starting nx")?;
        let screen = Arc::new(Mutex::new(Screen::default()));
        let sink = Arc::clone(&screen);
        std::thread::spawn(move || {
            let mut buf = [0u8; 8192];
            // the pipe closes when the child (and anything it started) exits
            while let Ok(n) = reader.read(&mut buf) {
                if n == 0 {
                    break;
                }
                if let Ok(mut s) = sink.lock() {
                    s.feed(&String::from_utf8_lossy(&buf[..n]));
                }
            }
        });
        Ok(Job {
            label: label.to_string(),
            command: format!("nx {}", args.join(" ")),
            screen,
            child,
            started: Instant::now(),
            finished: None,
            scroll: None,
            stats: Stats::new(),
        })
    }

    /// Check for exit and refresh the stats; call every tick.
    pub fn poll(&mut self) {
        if self.finished.is_none()
            && let Ok(Some(status)) = self.child.try_wait()
        {
            self.finished = Some((status.success(), self.started.elapsed()));
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
    use super::Screen;

    fn screen(input: &str) -> Vec<String> {
        let mut s = Screen::default();
        s.feed(input);
        s.lines
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
    fn colours_are_dropped() {
        assert_eq!(screen("\x1b[1;32m>\x1b[0m done\n"), ["> done"]);
    }

    #[test]
    fn redrawn_tree_does_not_repeat() {
        // how nom redraws a two-line status: up two lines, erase each, write again
        let frame = |n: u32| format!("building {n}\nstatus\n");
        let mut s = Screen::default();
        s.feed(&frame(1));
        s.feed(&format!("\x1b[2F\x1b[2K{}", frame(2)));
        assert_eq!(s.lines, ["building 2", "status"]);
    }

    #[test]
    fn osc_titles_are_skipped() {
        assert_eq!(screen("\x1b]0;title\x07text\n"), ["text"]);
    }
}
