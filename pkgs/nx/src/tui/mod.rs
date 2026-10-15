//! `nx tui`: tabs for status, apps, storage, doctor, generations and lines of code.
//! Data loads in background threads so the UI never freezes; the heavy tabs (apps,
//! storage) only measure when asked. Actions (update, build, switch, …) run `nx <command>`
//! inside the TUI, with its output in a pane and live system stats below.

mod job;
mod theme;
mod view;

use crate::cmd::{apps, doctor, loc, rollback, status, storage};
use crate::sh::Paths;
use anyhow::Result;
use job::Job;
use ratatui::crossterm::event::{self, Event, KeyCode, KeyEvent, KeyEventKind, KeyModifiers};
use ratatui::widgets::{ListState, TableState};
use std::sync::mpsc::{Receiver, Sender, channel};
use std::time::Duration;

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum Tab {
    Status,
    Apps,
    Storage,
    Doctor,
    Generations,
    Code,
}

impl Tab {
    pub const ALL: [Tab; 6] = [
        Tab::Status,
        Tab::Apps,
        Tab::Storage,
        Tab::Doctor,
        Tab::Generations,
        Tab::Code,
    ];
    pub fn title(self) -> &'static str {
        ["Status", "Apps", "Storage", "Doctor", "Generations", "Code"][self as usize]
    }
    /// Tabs that take a while to measure; they wait for Enter instead of loading on sight.
    fn heavy(self) -> bool {
        matches!(self, Tab::Apps | Tab::Storage)
    }
}

/// Data that loads in the background.
pub enum Load<T> {
    Idle,
    Loading,
    Ready(T),
    Failed(String),
}

enum Loaded {
    Status(Result<status::Status>),
    Apps(Result<Vec<apps::App>>),
    Storage(storage::Report),
    Doctor(Result<Vec<doctor::Check>>),
    Generations(Vec<rollback::Generation>, Vec<rollback::Generation>),
    Code(Result<Vec<loc::Group>>),
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum SortBy {
    Unique,
    Closure,
    Name,
}

/// A command waiting for its y/n.
pub struct Action {
    pub label: String,
    pub args: Vec<String>,
    /// needs sudo (nh activation, gc of the system profile, journal vacuum)
    root: bool,
}

pub struct App {
    paths: Paths,
    tx: Sender<Loaded>,
    rx: Receiver<Loaded>,
    pub tab: Tab,
    pub status: Load<status::Status>,
    pub apps: Load<Vec<apps::App>>,
    pub storage: Load<storage::Report>,
    pub doctor: Load<Vec<doctor::Check>>,
    pub generations: Load<(Vec<rollback::Generation>, Vec<rollback::Generation>)>,
    pub code: Load<Vec<loc::Group>>,
    pub apps_table: TableState,
    pub filter: String,
    pub filtering: bool,
    pub show_small: bool,
    pub sort: SortBy,
    /// false = NixOS list, true = home-manager list
    pub gens_home: bool,
    pub gens_list: ListState,
    pub confirm: Option<Action>,
    /// confirmed, waiting for the main loop (which owns the terminal) to start it
    pending: Option<Action>,
    pub job: Option<Job>,
    pub message: Option<String>,
    quit: bool,
}

impl App {
    fn new(paths: Paths) -> Self {
        let (tx, rx) = channel();
        App {
            paths,
            tx,
            rx,
            tab: Tab::Status,
            status: Load::Idle,
            apps: Load::Idle,
            storage: Load::Idle,
            doctor: Load::Idle,
            generations: Load::Idle,
            code: Load::Idle,
            apps_table: TableState::default().with_selected(Some(0)),
            filter: String::new(),
            filtering: false,
            show_small: false,
            sort: SortBy::Unique,
            gens_home: false,
            gens_list: ListState::default().with_selected(Some(0)),
            confirm: None,
            pending: None,
            job: None,
            message: None,
            quit: false,
        }
    }

    /// Start loading `tab` if it hasn't been (or `force` to refresh).
    fn load(&mut self, tab: Tab, force: bool) {
        let tx = self.tx.clone();
        let paths = self.paths.clone();
        macro_rules! spawn {
            ($field:ident, $job:expr) => {
                if force || matches!(self.$field, Load::Idle) {
                    self.$field = Load::Loading;
                    std::thread::spawn(move || {
                        let _ = tx.send($job(paths));
                    });
                }
            };
        }
        match tab {
            Tab::Status => spawn!(status, |p: Paths| Loaded::Status(status::collect(&p))),
            Tab::Apps => spawn!(apps, |_| Loaded::Apps(apps::collect())),
            Tab::Storage => spawn!(storage, |_| Loaded::Storage(storage::collect(
                &storage::Args::report()
            ))),
            Tab::Doctor => spawn!(doctor, |p: Paths| Loaded::Doctor(doctor::collect(&p))),
            Tab::Generations => spawn!(generations, |_| Loaded::Generations(
                rollback::system(),
                rollback::home()
            )),
            Tab::Code => spawn!(code, |p: Paths| Loaded::Code(loc::collect(&p))),
        }
    }

    /// After an action: refresh the cheap tabs that were open; the heavy ones keep their
    /// numbers until you reload them (r).
    fn refresh_after_job(&mut self) {
        for tab in Tab::ALL {
            let seen = match tab {
                Tab::Status => !matches!(self.status, Load::Idle),
                Tab::Doctor => !matches!(self.doctor, Load::Idle),
                Tab::Generations => !matches!(self.generations, Load::Idle),
                Tab::Code => !matches!(self.code, Load::Idle),
                Tab::Apps | Tab::Storage => false,
            };
            if seen {
                self.load(tab, true);
            }
        }
    }

    fn receive(&mut self) {
        fn ready<T>(r: Result<T>) -> Load<T> {
            r.map_or_else(|e| Load::Failed(format!("{e:#}")), Load::Ready)
        }
        while let Ok(msg) = self.rx.try_recv() {
            match msg {
                Loaded::Status(r) => self.status = ready(r),
                Loaded::Apps(r) => self.apps = ready(r),
                Loaded::Storage(r) => self.storage = Load::Ready(r),
                Loaded::Doctor(r) => self.doctor = ready(r),
                Loaded::Generations(os, home) => self.generations = Load::Ready((os, home)),
                Loaded::Code(r) => self.code = ready(r),
            }
        }
    }

    /// Apps after filter, size-class toggle and sort.
    pub fn visible_apps(&self) -> Vec<&apps::App> {
        let Load::Ready(list) = &self.apps else {
            return vec![];
        };
        let needle = self.filter.to_lowercase();
        let mut v: Vec<&apps::App> = list
            .iter()
            .filter(|a| self.show_small || !needle.is_empty() || a.class() != apps::Class::Small)
            .filter(|a| a.name.to_lowercase().contains(&needle))
            .collect();
        match self.sort {
            SortBy::Unique => v.sort_by_key(|a| std::cmp::Reverse(a.unique)),
            SortBy::Closure => v.sort_by_key(|a| std::cmp::Reverse(a.closure)),
            SortBy::Name => v.sort_by(|a, b| a.name.cmp(&b.name)),
        }
        v
    }

    pub fn current_generations(&self) -> &[rollback::Generation] {
        match &self.generations {
            Load::Ready((os, home)) => {
                if self.gens_home {
                    home
                } else {
                    os
                }
            }
            _ => &[],
        }
    }

    fn ask(&mut self, label: &str, args: &[&str], root: bool) {
        self.confirm = Some(Action {
            label: label.to_string(),
            args: args.iter().map(|s| s.to_string()).collect(),
            root,
        });
    }

    fn key(&mut self, k: KeyEvent) {
        self.message = None;
        let ctrl_c = k.code == KeyCode::Char('c') && k.modifiers.contains(KeyModifiers::CONTROL);

        // a running or finished job owns the screen
        if let Some(job) = &mut self.job {
            let running = job.finished.is_none();
            let lines = job.screen.lock().map(|s| s.lines.len()).unwrap_or(0);
            match k.code {
                _ if ctrl_c && running => job.stop(),
                KeyCode::Up | KeyCode::Char('k') => {
                    job.scroll = Some(job.scroll.unwrap_or(lines).saturating_sub(1))
                }
                KeyCode::PageUp => {
                    job.scroll = Some(job.scroll.unwrap_or(lines).saturating_sub(20))
                }
                KeyCode::Down | KeyCode::Char('j') | KeyCode::PageDown => {
                    let step = if k.code == KeyCode::PageDown { 20 } else { 1 };
                    job.scroll = job.scroll.map(|s| s + step).filter(|s| *s < lines);
                }
                KeyCode::End | KeyCode::Char('f') | KeyCode::Char('G') => job.scroll = None,
                KeyCode::Esc | KeyCode::Char('q') | KeyCode::Enter if !running => {
                    self.job = None;
                    self.refresh_after_job();
                }
                _ if running => self.message = Some("still running (Ctrl+C stops it)".into()),
                _ => {}
            }
            return;
        }

        // a pending y/n question takes every key
        if let Some(action) = self.confirm.take() {
            if matches!(k.code, KeyCode::Char('y') | KeyCode::Enter) {
                self.pending = Some(action);
            }
            return;
        }

        // typing a filter on the apps tab
        if self.filtering {
            match k.code {
                KeyCode::Esc => {
                    self.filtering = false;
                    self.filter.clear();
                }
                KeyCode::Enter => self.filtering = false,
                KeyCode::Backspace => {
                    self.filter.pop();
                }
                KeyCode::Char(c) => self.filter.push(c),
                _ => {}
            }
            self.apps_table.select(Some(0));
            return;
        }

        match k.code {
            KeyCode::Char('q') | KeyCode::Esc => self.quit = true,
            _ if ctrl_c => self.quit = true,
            // left/right move between tabs, except on Generations where they pick the list
            KeyCode::Tab => self.step_tab(1),
            KeyCode::BackTab => self.step_tab(Tab::ALL.len() - 1),
            KeyCode::Right | KeyCode::Char('l') if self.tab != Tab::Generations => self.step_tab(1),
            KeyCode::Left | KeyCode::Char('h') if self.tab != Tab::Generations => {
                self.step_tab(Tab::ALL.len() - 1)
            }
            KeyCode::Char(c @ '1'..='6') => self.switch(c as usize - '1' as usize),
            KeyCode::Char('r') => self.load(self.tab, true),
            KeyCode::Enter if self.heavy_waiting() => self.load(self.tab, true),

            // actions: capitals, so they never clash with moving around
            KeyCode::Char('U') => self.ask("Update both flake.lock files", &["update"], false),
            KeyCode::Char('B') => self.ask(
                "Build os and home (nothing is activated)",
                &["build"],
                false,
            ),
            KeyCode::Char('S') => self.ask("Switch the system", &["os", "switch"], true),
            KeyCode::Char('T') => self.ask(
                "Test the system (active now, not the boot default)",
                &["os", "test"],
                true,
            ),
            KeyCode::Char('H') => self.ask(
                "Switch home (conflicting files become .bak)",
                &["home", "switch", "-b"],
                false,
            ),
            KeyCode::Char('A') => self.ask("Update, then switch system and home", &["all"], true),
            KeyCode::Char('C') => self.ask(
                "Clean: keep the newest 4 generations, then gc",
                &["clean"],
                true,
            ),
            KeyCode::Char('D') => self.ask("Show changes since boot", &["diff"], false),
            KeyCode::Char('X') if self.tab == Tab::Storage => self.ask(
                "Delete the regenerable caches, vacuum the journal, prune docker/flatpak",
                &["storage", "clean", "--yes"],
                true,
            ),
            _ => self.tab_key(k),
        }
    }

    /// On Apps or Storage before they've been measured (or after a failure).
    pub fn heavy_waiting(&self) -> bool {
        match self.tab {
            Tab::Apps => matches!(self.apps, Load::Idle | Load::Failed(_)),
            Tab::Storage => matches!(self.storage, Load::Idle | Load::Failed(_)),
            _ => false,
        }
    }

    fn tab_key(&mut self, k: KeyEvent) {
        match self.tab {
            Tab::Apps => {
                let len = self.visible_apps().len();
                match k.code {
                    KeyCode::Char('/') => self.filtering = true,
                    KeyCode::Char('a') => {
                        self.show_small = !self.show_small;
                        self.apps_table.select(Some(0));
                    }
                    KeyCode::Char('s') => {
                        self.sort = match self.sort {
                            SortBy::Unique => SortBy::Closure,
                            SortBy::Closure => SortBy::Name,
                            SortBy::Name => SortBy::Unique,
                        };
                    }
                    _ => move_selection(&mut self.apps_table, k.code, len),
                }
            }
            Tab::Generations => {
                let len = self.current_generations().len();
                match k.code {
                    KeyCode::Left | KeyCode::Right | KeyCode::Char('h') | KeyCode::Char('l') => {
                        self.gens_home = !self.gens_home;
                        self.gens_list.select(Some(0));
                    }
                    KeyCode::Enter => {
                        let Some(g) = self
                            .gens_list
                            .selected()
                            .and_then(|i| self.current_generations().get(i))
                        else {
                            return;
                        };
                        if g.current {
                            self.message = Some("that is the current generation".into());
                            return;
                        }
                        let id = g.id.clone();
                        let (what, target, root) = if self.gens_home {
                            ("home", "home", false)
                        } else {
                            ("the system", "os", true)
                        };
                        self.ask(
                            &format!("Roll {what} back to generation {id}"),
                            &["rollback", target, &id],
                            root,
                        );
                    }
                    _ => {
                        let mut state =
                            TableState::default().with_selected(self.gens_list.selected());
                        move_selection(&mut state, k.code, len);
                        self.gens_list.select(state.selected());
                    }
                }
            }
            _ => {}
        }
    }

    fn step_tab(&mut self, by: usize) {
        self.switch((self.tab as usize + by) % Tab::ALL.len());
    }

    fn switch(&mut self, i: usize) {
        self.tab = Tab::ALL[i];
        if !self.tab.heavy() {
            self.load(self.tab, false);
        }
    }
}

fn move_selection(state: &mut TableState, code: KeyCode, len: usize) {
    if len == 0 {
        return;
    }
    let i = state.selected().unwrap_or(0);
    let next = match code {
        KeyCode::Down | KeyCode::Char('j') => (i + 1).min(len - 1),
        KeyCode::Up | KeyCode::Char('k') => i.saturating_sub(1),
        KeyCode::PageDown => (i + 15).min(len - 1),
        KeyCode::PageUp => i.saturating_sub(15),
        KeyCode::Home | KeyCode::Char('g') => 0,
        KeyCode::End | KeyCode::Char('G') => len - 1,
        _ => i,
    };
    state.select(Some(next));
}

/// sudo without a password prompt works (cached, or NOPASSWD)?
fn sudo_ready() -> bool {
    crate::sh::succeeds(crate::sh::cmd("sudo").args(["-n", "true"]))
}

pub fn run(paths: &Paths) -> Result<()> {
    let mut app = App::new(paths.clone());
    app.load(Tab::Status, false);
    let mut terminal = ratatui::init();
    let result = (|| -> Result<()> {
        while !app.quit {
            app.receive();
            if let Some(job) = &mut app.job {
                job.poll();
            }
            terminal.draw(|f| view::draw(f, &mut app))?;
            if event::poll(Duration::from_millis(100))?
                && let Event::Key(k) = event::read()?
                && k.kind == KeyEventKind::Press
            {
                app.key(k);
            }
            if let Some(action) = app.pending.take() {
                // the job's output goes to a pane, so a sudo password prompt there would
                // hang; ask for it up front on the plain terminal when it isn't cached
                if action.root && !sudo_ready() {
                    ratatui::restore();
                    println!("nx needs sudo for: {}", action.label);
                    let ok = crate::sh::run(crate::sh::cmd("sudo").arg("-v")).unwrap_or(false);
                    terminal = ratatui::init();
                    terminal.clear()?;
                    if !ok {
                        app.message = Some("sudo failed, nothing was run".into());
                        continue;
                    }
                }
                match Job::start(&action.label, &action.args) {
                    Ok(job) => app.job = Some(job),
                    Err(e) => app.message = Some(format!("could not start: {e:#}")),
                }
            }
        }
        Ok(())
    })();
    if let Some(job) = &mut app.job
        && job.finished.is_none()
    {
        job.stop();
    }
    ratatui::restore();
    result
}
