# Install Pin1yin1.com Pinyin Converter (WIP)

This document runs through the steps to install a version of the Pin1yin1.com
Pinyin converter.

## Install the database
MySQL is the default database for Pin1yin1.com.

For Ubuntu:
`# apt-get install mariadb-server`

For Debian:
`# apt-get install mysql-server`

For RHEL/CentOS/Fedora:
`# yum install mariadb mariadb-server`

For openSUSE/SLES:
`# zypper install mariadb-client mariadb`


Create a new configuration file ('cnf') for Pin1yin1 in the appropriate
location for your distribution:
* Ubuntu/Debian: `/etc/mysql/conf.d/pin1yin1.cnf`
* RHEL/CentOS/Fedora/SUSE: `/etc/my.cnf.d/pin1yin1.cnf`

Then edit the `[mysqld]` section, set the following keys to enable
useful options and the UTF-8 character set:

```
[mysqld]
...
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
character-set-server = utf8
```

Restart the service to allow the changes to take effect:
* Ubuntu/Debian: `service mysql restart`
* RHEL/CentOS/Fedora: `systemctl enable mariadb.service; systemctl start mariadb.service`
* SUSE: `systemctl enable mysql.service; systemctl start mysql.service`

Finally, secure the database by running `mysql_secure_installation`


## Configure the database

`$ mysql -u root -p`

```
CREATE DATABASE pin1yin1_test;
CREATE DATABASE pin1yin1_development;
GRANT ALL PRIVILEGES ON pin1yin1_development.* TO 'pin1yin1'@'localhost' \
  IDENTIFIED BY 'PIN1YIN1_DBPASS';
GRANT ALL PRIVILEGES ON pin1yin1_development.* TO 'pin1yin1'@'%' \
  IDENTIFIED BY 'PIN1YIN1_DBPASS';
GRANT ALL PRIVILEGES ON pin1yin1_test.* TO 'pin1yin1'@'localhost' \
  IDENTIFIED BY 'PIN1YIN1_DBPASS';
GRANT ALL PRIVILEGES ON pin1yin1_test.* TO 'pin1yin1'@'%' \
  IDENTIFIED BY 'PIN1YIN1_DBPASS';
```

## Install Ruby

The version of ruby required by Pin1yin1 is specified in `.ruby-version`.
If you have this version already, you can skip this section.

First, set up [chruby](https://github.com/postmodern/chruby)) to deal with
managing multiple ruby versions on your system. For example, version 0.3.9

```
$ wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
$ tar -xzvf chruby-0.3.9.tar.gz
$ cd chruby-0.3.9/
$ sudo make install
```

adding the lines to `~/.bashrc` is recommended - since chruby can automatically
change to the right version of ruby when you `cd` to the pin1yin1 directory:

```
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
```

To install the right version of ruby, try
[ruby-installer](https://github.com/postmodern/ruby-instal)):
```
wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
tar -xzvf ruby-install-0.6.0.tar.gz
cd ruby-install-0.6.0/
sudo make install
```

Install the required version into /usr/local:
`$  ruby-install --system ruby 2.4.0`

## Install the pre-requisites
In the pin1yin1 directory, run the following commands to get the required gems:
```
$ gem install bundler
$ bundle
```

Some distributions require `phantomjs` to be install separately:
* Ubuntu/Debian: `$ sudo apt-get install phantomjs`
* NPM: `$ npm install -g phantomjs`


## Set up the database and schema
The configuration assumes the database is running on localhost with the user
pin1yin1. If that is different for you, edit `config/database.yml`

Now, run the DB setup:

```
$ export PIN1YIN1_TEST_USERNAME=pin1yin1
$ export PIN1YIN1_DEVELOPMENT_USERNAME=pin1yin1
$ export PIN1YIN1_TEST_PASSWORD=PIN1YIN1_DBPASS
$ export PIN1YIN1_DEVELOPMENT_PASSWORD=PIN1YIN1_DBPASS
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

## Importing dictionary data

Now it is time to import all of the dictionary data.
This takes several minutes, so get ready to take a break while the import runs.

`$ bundle exec rake db:import`

Note that by default, the data will be imported to the development
environment. If you want to import it into the test or production environment,
simply export the appropriate RAILS_ENV. For example:

`$ RAILS_ENV=production bundle exec rake db:import`

## Testing the install
There is a (currently small) rspec-based test suite included. If you
have installed the software correctly, you should be able to run it
with:

    PIN1YIN1_TEST_PASSWORD=password bundle exec rake spec

where "password" is your test database password.

## Starting a server

Now that you have the database and application configured,
you can set up a server running Pin1yin1.

To start a development server, run:

```
$ export PIN1YIN1_DEVELOPMENT_PASSWORD=PIN1YIN1_DBPASS
$ bundle exec rails server
```

## Optional environment variables

Set BAD_WORDS_FILE to a file that contains a list of English words,
one per line. If any of these words appears on a page, ads will not be
shown. This is required to avoid getting blocked by Google. Read [the
AdSense
policy](https://support.google.com/adsense/answer/1348688?hl=en) for
more information.
