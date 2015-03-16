# RubyAdvisoryDbCheck

This Gem provides a rake task that automatically checks your installed Gems
with the [ruby-advisory-db Database](https://github.com/rubysec/ruby-advisory-db).
The rake task will fail and output the affected Gems if there are any advisories.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-advisory-db-check'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-advisory-db-check

## Usage

    $ rake advisory_db:check

## Contributing

1. Fork it ( http://github.com/tbraun89/ruby-advisory-db-check/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Articles

 * https://www.tnt-web-solutions.de/blog/2015/03/16/ruby-gem-sicherheit.html (German)
