use reqwest::blocking as req;
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};

pub(super) fn resolve_request(url: &str, dir_root: &Path) -> anyhow::Result<PathBuf> {
    let response = req::get(url)?;

    let fname = response
        .url()
        .path_segments()
        .and_then(|segments| segments.last())
        .and_then(|name| if name.is_empty() { None } else { Some(name) })
        .unwrap_or("tmp.bin");

    let fname = dir_root.join(fname);

    let mut dest = File::create(&fname)?;

    let content = response.bytes()?;
    dest.write_all(&content)?;

    Ok(fname)
}

// look for paths in file
pub(super) fn find_paths(_fname: File) {}
