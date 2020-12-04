use anyhow::Result;
use flate2::read::GzDecoder;
use std::env;
use std::iter;
use std::path::PathBuf;
use structopt::StructOpt;
use tar::Archive;

const DEFAULT_GATEWAY: &str = "https://ipfs.io";

#[derive(StructOpt, Debug)]
struct Opt {
    target: String,
    addr: String,

    #[structopt(
        long,
        short = "g",
        env = "IPFS_GATEWAY",
        default_value = DEFAULT_GATEWAY,
    )]
    ipfs_gateway: String,
}

fn download(opt: &Opt) -> Result<()> {
    let url = format!("{}/{}", opt.ipfs_gateway, opt.addr);

    println!("Downloading {}", url);
    let body = reqwest::blocking::get(&url)?.bytes()?;

    let tar = GzDecoder::new(&body[..]);
    let mut archive = Archive::new(tar);

    archive.unpack(&opt.target)?;

    Ok(())
}

#[derive(StructOpt, Debug)]
#[structopt(
    about = "This is a shell shim for the the flayers command. Pass arguments to flayers via the -c flag."
)]
struct ShellShimOpt {
    #[structopt(
        short,
        help = "Passes options to the flayers command; pass -c '. --help' to get the help of the flayers command itself."
    )]
    cmd: String,
}

fn binary(args: &mut impl Iterator<Item = String>) -> String {
    let path = match args.next() {
        Some(ref s) if !s.is_empty() => PathBuf::from(s),
        _ => std::env::current_exe().unwrap(),
    };
    path.file_stem().unwrap().to_str().unwrap().to_string()
}

fn main() -> Result<()> {
    let bin = binary(&mut env::args());

    let opt: Opt;
    if bin == "sh" {
        let shopt = ShellShimOpt::from_args();
        let sub_args = iter::once("flayers").chain(shopt.cmd.split_whitespace());
        opt = Opt::from_iter(sub_args);
    } else {
        opt = Opt::from_args();
    }

    download(&opt)
}
