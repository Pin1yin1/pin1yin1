let
  mynix = import ./defs.nix;
  pkgs = mynix.pkgs;
  shell = import ./shell.nix;
  lib = pkgs.lib;

  # Keep local databases, generated assets, and editor files out of the build.
  excluded = [
    ".git" ".agents" ".aws" ".codex" ".bundle"
    "tmp" "log" "index" "result" "public/assets" "vendor/bundle"
  ];
  source = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let relative = lib.removePrefix "${toString ./.}/" (toString path);
      in !(lib.any (entry: relative == entry || lib.hasPrefix "${entry}/" relative) excluded);
  };
in

pkgs.stdenvNoCC.mkDerivation {
  pname = "pin1yin1";
  version = "1";
  src = source;

  nativeBuildInputs = shell.buildInputs;
  inherit (shell) CHROME_BIN CHROMEDRIVER;
  RAILS_ENV = "production";

  buildPhase = ''
    runHook preBuild
    export HOME="$TMPDIR"
    export RAILS_SECRET_KEY_BASE=0000000000000000000000000000000000000000000000000000000000000000
    export RAILS_PRODUCTION_DATABASE=pin1yin1_production
    bundle exec rails assets:precompile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r . "$out/"
    mkdir -p "$out/tmp/pids" "$out/tmp/sockets" "$out/log"
    {
      echo '#!${pkgs.bashInteractive}/bin/bash'
      printf 'export PATH=%q:"$PATH"\n' '${lib.makeBinPath shell.buildInputs}'
      printf 'export GEM_PATH=%q\n' "$GEM_PATH"
      printf 'export RUBYLIB=%q\n' "$RUBYLIB"
      printf 'export CHROME_BIN=%q\n' "$CHROME_BIN"
      printf 'export CHROMEDRIVER=%q\n' "$CHROMEDRIVER"
      echo 'if [[ -z "$RAILS_INDEX_DIR" ]]; then export RAILS_INDEX_DIR="$HOME/.local/state/pin1yin1/index"; fi'
      echo 'if [[ -z "$RAILS_STORAGE_ROOT" ]]; then export RAILS_STORAGE_ROOT="$HOME/.local/state/pin1yin1/storage"; fi'
      echo 'exec ${pkgs.bashInteractive}/bin/bash "$@"'
    } > "$out/shell.sh"
    chmod +x "$out/shell.sh"
    runHook postInstall
  '';
}
