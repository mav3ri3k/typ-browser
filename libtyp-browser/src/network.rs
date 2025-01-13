use super::FileType;
use reqwest::blocking as req;
use std::fs::File;
use std::io::Write;
use tempfile::TempDir;

use crate::util::*;

pub(super) fn resolve_request(url: &str, dir: &Dir) -> anyhow::Result<FileType> {
    let response = req::get(url)?;

    let fname = response
        .url()
        .path_segments()
        .and_then(|segments| segments.last())
        .and_then(|name| if name.is_empty() { None } else { Some(name) })
        .unwrap_or("tmp.bin");

    println!("file to download: '{}'", fname);
    let fname = dir.tmp_dir.path().join(fname);
    println!("will be located under: '{:?}'", fname);

    let mut dest = File::create(&fname)?;

    let content = response.bytes()?;
    dest.write_all(&content)?;

    Ok(FileType::new(&fname))
}

// look for paths in file
pub(super) fn find_paths(fname: File) {}
