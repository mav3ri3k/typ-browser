use anyhow::Result;
use std::path::Path;
use tempfile::Builder;
use tempfile::TempDir;

use crate::network;

pub struct File {
    fname: std::fs::File,
    resolved: bool,
}

// Temporary Directory
pub struct Dir {
    pub tmp_dir: TempDir,
    pub unresolved: Vec<String>,
}

impl Dir {
    pub fn new() -> Self {
        Dir {
            tmp_dir: Builder::new().prefix("typorium").tempdir().unwrap(),
            unresolved: Vec::new(),
        }
    }

    fn add_unresolved(&mut self, str: String) {
        self.unresolved.push(str);
    }

    fn resolve_all(&mut self) -> Result<()> {
        while !self.unresolved.is_empty() {
            for url in self.unresolved.drain(..) {
                network::resolve_request(&url, &self);
            }
        }
        Ok(())
    }
}

enum FileType {
    Typst,
    Other,
}

impl FileType {
    fn new(fname: &Path) -> Self {
        //TODO Remove unwrap
        if fname.extension().unwrap() == "typ" {
            FileType::Typst
        } else {
            FileType::Other
        }
    }
}
