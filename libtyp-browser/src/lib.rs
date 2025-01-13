use std::ffi::CStr;
use std::os::raw::c_char;
use std::process::Command;
use tempfile::Builder;
use url::Url;

mod network;
mod util;

#[no_mangle]
pub extern "C" fn run(entry: *const c_char) -> u8 {
    // Convert the C string to a Rust string
    let c_str = unsafe {
        assert!(!entry.is_null());
        CStr::from_ptr(entry)
    };

    let input_url = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => {
            eprintln!("Invalid UTF-8 string passed to compile function.");
            return 0;
        }
    };

    let dir = util::Dir::new();
    let tmp_dir = Builder::new().prefix("typorium").tempdir()?;

    let x = "some";
    let _ = network::resolve_request(&x, &tmp_dir);
    compile(input_url)
}

fn compile(input_url: &str) -> u8 {
    let file_path = match Url::parse(input_url) {
        Ok(url) => {
            if url.scheme() == "file" {
                // Extract and validate the path
                if let Some(path) = url.to_file_path().ok() {
                    path
                } else {
                    return 1;
                }
            } else {
                println!("Not a file URI. Scheme: {}", url.scheme());
                return 2;
            }
        }
        Err(e) => {
            println!("Invalid URI: {}", e);
            return 1;
        }
    };

    // Execute the Typst CLI command
    let status = Command::new("/Users/apurva/.cargo/bin/typst")
        .arg("compile")
        .arg(file_path.clone())
        .status();

    let status = match status {
        Ok(st) => st,
        Err(_) => {
            let status = Command::new("which typst")
                .status()
                .expect("impossible, pwd failed!");
            println!(
                "Failed to execute Typst CLI. Current dir: {}, Input File: {}",
                status,
                file_path.to_str().expect("not possible")
            );
            return 0;
        }
    };

    if status.success() {
        println!("Successfully compiled {:?}", file_path.to_str());
        1
    } else {
        eprintln!("Failed to compile the Typst document.");
        0
    }
}
