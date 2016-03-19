# Pin1yin1.com Pinyin Converter source repository

[Pin1yin1.com](http://www.pin1yin1.com/) is a simple tool designed to
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

    PIN1YIN1_TEST_PASSWORD=password bundle exec rake spec

where "password" is your test database password.

Once you have a feature or bugfix that you would like to share, please
send me a pull request via GitHub.

## Documentation TODO

* Step-by-step database setup.
* Procedure for importing dictionary data.
* Deployment process.
