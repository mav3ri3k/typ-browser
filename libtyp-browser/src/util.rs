use anyhow::Result;
use std::path::Path;
use std::path::PathBuf;
use tempfile::Builder;
use tempfile::TempDir;

use crate::network;

pub struct File {
    fname: std::fs::File,
    parsed: bool,
    file_type: FileType,
}

impl File {
    fn new(fname: std::fs::File, file_type: FileType) -> Self {
        File {
            fname,
            parsed: false,
            file_type,
        }
    }
}

// Temporary Directory
pub struct Dir {
    pub root_path: PathBuf,
    pub root_file: Option<PathBuf>,
    pub unresolved: Vec<String>,
}

impl Dir {
    pub fn new(root_path: &str) -> Self {
        Dir {
            root_path: PathBuf::from(root_path),
            root_file: None,
            unresolved: Vec::new(),
        }
    }

    pub fn get_root(&mut self, url: &str) -> Result<()> {
        let fname = network::resolve_request(url, &self.root_path)?;
        match FileType::new(&fname) {
            FileType::Typst => {
                self.root_file = Some(fname);
                Ok(())
            }
            FileType::Other => Err(anyhow::anyhow!("Recieved file is not a typst document")),
        }
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
