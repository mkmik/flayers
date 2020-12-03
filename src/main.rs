use flate2::read::GzDecoder;
use std::env;
use tar::Archive;

const GATEWAY: &str = "https://ipfs.io";

fn main() -> Result<(), std::io::Error> {
    let mut args = env::args();
    args.next();
    args.next();
    let cmd = args.next().unwrap();
    let mut comp = cmd.split_whitespace();

    let target = comp.next().unwrap();
    let addr = comp.next().unwrap();
    let url = format!("{}/{}", GATEWAY, addr);

    println!("Downloading {}", url);
    let body = reqwest::blocking::get(&url).unwrap().bytes().unwrap();

    let tar = GzDecoder::new(&body[..]);
    let mut archive = Archive::new(tar);

    archive.unpack(target)?;

    Ok(())
}
