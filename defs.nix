# Some useful defintions.

rec {
  pinTarball = { version, name, url, sha256 }:
    fetchTarball {
      name = "${name}-${version}";
      inherit url;
      inherit sha256;
    };

  pinTarballGithub = { version, name, owner, sha256 }:
    fetchTarball {
      name = "${name}-${version}";
      url = "https://github.com/${owner}/${name}/archive/${version}.tar.gz";
      inherit sha256;
    };

  # nixos-26.05 from 2026-10-15:
  nixpkgs = pinTarballGithub {
    version = "a033e66";
    owner = "NixOS";
    name = "nixpkgs";
    sha256 = "140gms89455qvs29g7zwnx66z0h9ycf4hvfg7lh84rqi79sh7yfa";
  };
  pkgs = (import nixpkgs {});

  mkBuildableShell-src = pinTarballGithub {
    version = "39a7d89";
    owner = "pdg137";
    name = "mkBuildableShell";
    sha256 = "1na7c6xzgjqsm2j00ivaqq8pql69d63afd3lisb6mzvj17gfsn3y";
  };
  mkBuildableShell = (import mkBuildableShell-src pkgs);
}
