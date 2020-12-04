use flate2::read::GzDecoder;
use std::env;
use tar::Archive;
use anyhow::Result;

const GATEWAY: &str = "https://ipfs.io";

struct Opt {
  target: String,
  addr: String,
}

fn download(opt: &Opt) -> Result<()> {
    let url = format!("{}/{}", GATEWAY, opt.addr);

    println!("Downloading {}", url);
    let body = reqwest::blocking::get(&url)?.bytes()?;

    let tar = GzDecoder::new(&body[..]);
    let mut archive = Archive::new(tar);

    archive.unpack(&opt.target)?;

    Ok(())
}

fn main() -> Result<()> {
    let mut args = env::args();
    args.next();
    args.next();
    let cmd = args.next().unwrap();
    let mut comp = cmd.split_whitespace();

    let target = comp.next().unwrap();
    let addr = comp.next().unwrap();

    let opt = Opt {
      target: target.to_string(),
      addr: addr.to_string(),
    };

	download(&opt)
}
