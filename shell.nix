let
  mynix = import ./defs.nix;
  pkgs = mynix.pkgs;

  gemset = import ./build_gemset.nix pkgs {
    # If you update Gemfile.lock, you will need to revise this hash.
    hash = "sha256-Fr5iTdJ9ZRiW7VC9naPf1LgfzAlazucTnpzbt7eU4aY=";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
  };

  our_ruby_env = pkgs.bundlerEnv {
    name = "our_ruby_env";
    ruby = pkgs.ruby;

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = gemset.outPath;
  };

in

mynix.mkBuildableShell {
  name = "shell";
  buildInputs = [
    our_ruby_env
    pkgs.ruby
    pkgs.chromium
    pkgs.chromedriver
    pkgs.mariadb
    pkgs.nodejs
  ];
  CHROME_BIN = "${pkgs.chromium}/bin/chromium";
  CHROMEDRIVER = "${pkgs.chromedriver}/bin/chromedriver";
}
