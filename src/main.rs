use anyhow::Result;
use flate2::read::GzDecoder;
use structopt::StructOpt;
use tar::Archive;
use std::iter;

const GATEWAY: &str = "https://ipfs.io";

#[derive(StructOpt)]
#[derive(Debug)]
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

#[derive(StructOpt)]
#[derive(Debug)]
struct ShellShimOpt {
    #[structopt(short = "c")]
    cmd: String,
}

fn main() -> Result<()> {
    let shopt = ShellShimOpt::from_args();
    let sub_args = iter::once("flayers").chain(shopt.cmd.split_whitespace());
    let opt = Opt::from_iter(sub_args);
    download(&opt)
}
