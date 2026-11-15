# This derivation builds a gemset.nix file as a derivation that can be
# used in further nix configuration.  It will get rebuilt under a new
# outPath whenever Gemfile.lock changes.
#
# The advantage is that after changing Gemfile.lock, you don't have to
# manually run bundix; you only need to update one hash to allow the
# new gemset.nix to take effect.
#
# Use it like this:
#
# import ./build_gemset.nix pkgs {
#   # If you update Gemfile.lock, you will need to revise this hash.
#   hash = "sha256-K8IhoYmTQeEwq/iIlhom9bwTLLgSCaRxVxUfZ86bGxI=";
#   gemfile = ./Gemfile;
#   lockfile = ./Gemfile.lock;
# };
#
# Updating Gemfile.lock:
#   nix-shell -p ruby
#   bundle config force_ruby_platform true
#   bundle lock

pkgs:
{ hash, gemfile, lockfile }:

let

  # Make a unique name for the gemset file that is a function of
  # Gemfile.lock.  Without that, the outPath depends only on the
  # fixed-output hash, so changes to Gemfile.lock will not
  # automatically result in a new file getting built.  This forces the
  # rebuild.

  hashDrvInputs = drv:
    let
      inputs = { inherit (drv) builder args buildInputs gemfile lockfile; };
      json = builtins.toJSON inputs;
    in
      builtins.hashString "md5" json;

  uniqueGemsetName = "${hashDrvInputs gemset}-gemset.nix";

  gemset = pkgs.stdenv.mkDerivation {
    name = uniqueGemsetName;

    gemfile = gemfile;
    lockfile = lockfile;

    # Make it a fixed-output derivation to allow Internet downloads.
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = hash;

    buildInputs = [ pkgs.cacert pkgs.bundix pkgs.nix pkgs.openssl ];

    # To build gemset.nix we need nix-prefetch-url, which fails in
    # nix-build since it can't write to /var/nix.  So we create a fake
    # directory for it.
    builder = pkgs.writeShellScript "builder.sh" ''
      source $stdenv/setup
      export XDG_CACHE_HOME="$PWD"

      mkdir fake_nix
      export NIX_STORE_DIR="$PWD"/fake_nix/store
      export NIX_STATE_DIR="$PWD"/fake_nix/var/nix
      export NIX_LOG_DIR="$PWD"/fake_nix/var/log/nix

      echo bundix --lockfile=$lockfile --gemfile=$gemfile --gemset=$out
      bundix --lockfile=$lockfile --gemfile=$gemfile --gemset=$out
      sha256sum $out
    '';
  };
in
  gemset
