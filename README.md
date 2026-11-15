# Pin1yin1.com Pinyin Converter source repository

[Pin1yin1.com](https://www.pin1yin1.com/) is a simple tool designed to
help students of Mandarin Chinese learn the thousands of characters
(hànzì) of the Chinese writing system. To use it, you simply copy
passages from the web into the text box, and they will be annotated
with hànyǔ pīnyīn or zhùyīn pronunciation symbols. Click on any
character for a more detailed definition with a full list of usage
examples. With pin1yin1.com you can get out onto the web and start
reading Chinese now!

While maintaining this site for more than ten years, I have received
numerous "thank you" messages from people around the world, often
giving suggestions or offering support, but I have unfortunately had
little time to improve the site. I decided to share the code here for
three reasons:

1. As a place to document feature requests and progress;
2. To give the community a way to contribute code; and
3. To give people who depend on the site a backup option in case I stop maintaining it.

As described in `LICENSE.txt`, I have released the code under an MIT
license. Some files in `data/` have their own licenses. Feel free to
use this as the basis for your own alternative websites, apps, etc.

## Nix production package

From the repository root, build the package with:

    nix-build

You do not need to export any environment variables for this build.
`default.nix` sets `RAILS_ENV=production`, a temporary
`RAILS_SECRET_KEY_BASE`, and a build-time `RAILS_PRODUCTION_DATABASE`
while it precompiles assets. These values do not set the secret or
database used when the packaged site runs. The result is
linked at `result/` and includes `shell.sh` for the packaged Ruby and
gem environment.

Set these variables when running the production package or production
database tasks:

| Variable | Purpose |
| --- | --- |
| `RAILS_ENV=production` | Selects the production configuration. |
| `RAILS_PRODUCTION_DATABASE` | Name of the production MariaDB database. |
| `RAILS_PRODUCTION_USERNAME` | MariaDB user for that database. |
| `RAILS_PRODUCTION_PASSWORD` | Password for that MariaDB user. |
| `RAILS_SECRET_KEY_BASE` | The site's real, persistent Rails secret key. |

The package's `shell.sh` sets `RAILS_LOG_TO_STDOUT=1` and supplies Ruby,
gem, and Chromium paths. It also defaults the search index and Active
Storage directories to paths under `$HOME/.local/state/pin1yin1/`.
Ensure that the runtime user can write there. Override these settings
when needed:

| Variable | When to set it |
| --- | --- |
| `MYSQL_UNIX_PORT` | MariaDB uses a nondefault Unix socket. |
| `RAILS_SERVE_STATIC_FILES` | Set to any nonempty value to serve precompiled files from Rails. Leave unset or empty when another server serves them; even `false` enables it. |
| `RAILS_INDEX_DIR` | Store the search index somewhere other than `$HOME/.local/state/pin1yin1/index`. |
| `RAILS_STORAGE_ROOT` | Store Active Storage files somewhere other than `$HOME/.local/state/pin1yin1/storage`. |
| `RAILS_BAD_WORDS_FILE` | Read a word list used to suppress ads on matching pages. |

The database credentials and real secret are read at runtime; their
values do not need to be passed to `nix-build` and are not included in
the package.

To initialize a new production database, set the required variables
above, then run from the repository root:

    cd result
    ./shell.sh -c 'bundle exec rake db:create db:schema:load db:import'

`db:create` requires the MariaDB user to have permission to create the
database. If the database was created separately, run only
`db:schema:load db:import`. Load the schema only into a new, empty
database: it replaces existing tables. The import reads the bundled
dictionary files and populates the lookup tables and search index.

## Contributing

To contribute code, clone the repository and set up local
test and development databases "pin1yin1_test" and
"pin1yin1_development". Pin1yin1.com is configured for MySQL, but it
should work fine with Postgres (though some SQL code might need to
fixed).

Install the version of Ruby specified in `.ruby-version` (I
recommend using [chruby](https://github.com/postmodern/chruby)), then
run `gem install bundler` and `bundle` to get the required gems.

There is a (currently small) rspec-based test suite included. If you
have installed the software correctly, you should be able to run it
with:

    RAILS_TEST_PASSWORD=password bundle exec rake spec

where "password" is your test database password.

With Nix, the following command starts a temporary MariaDB instance,
loads the schema, and runs the specs with headless Chromium:

    nix-shell --run 'bash script/specs-in-nix'

To keep a local MariaDB test database with the bundled dictionary data,
run this from the repository root:

    nix-shell --run 'bash script/test-db'

The data is stored in `tmp/mariadb`. Keep that terminal open while using
the database; press Ctrl+C to stop MariaDB. Running the command again
keeps the existing data. To rebuild the database from the bundled data,
or to stop the server from another terminal, run:

    nix-shell --run 'bash script/test-db reload'
    nix-shell --run 'bash script/test-db stop'

With the database running in the first terminal, start the site in a
second terminal:

    nix-shell --run 'bash script/server-with-test-db'

The spec suite truncates its test database. Use `script/specs-in-nix` to
run specs without clearing the persistent imported data.

Once you have a feature or bugfix that you would like to share, please
send me a pull request via GitHub.

## Documentation TODO

* Deployment process.
