//! One module per command. Modules that report something (status, apps, storage,
//! doctor, rollback) split into "collect" (data, also used by the TUI) and "print".

pub mod apps;
pub mod doctor;
pub mod firmware;
pub mod loc;
pub mod rebuild;
pub mod rollback;
pub mod status;
pub mod storage;
pub mod tools;
pub mod try_greeter;
pub mod update;
