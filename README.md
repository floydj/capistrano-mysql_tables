# Capistrano::MysqlTables

Capistrano MysqlTables allows for easy transfer of MySQL tables between development and production
environments. 

## Requirements
This plugin makes a couple of assumptions:

* The existence of a `config/database.yml` file, as is used in Ruby on Rails environments.
* That your production ssh user has their MySQL password setup in a `~/.my.cnf`
file as shown below. This is for security reasons, we don't want to pull the password out
of the database.yml file and print to the command line.

```
[client]
password="your-super-cool-password"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-mysql_tables'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install capistrano-mysql_tables

Then add to your Capfile with:

    require "capistrano/mysql_tables"

## Usage

The plugin provides two self-explanatory tasks, `db:push_tables` and `db:pull_tables`.

Run a task without any arguments, eg. `cap production db:push_tables`, and you'll be asked to provide
one or more table names to move.
Or you can provide the table names directly: `cap production "db:push_tables[table1 table2]"`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
