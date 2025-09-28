# pkg-goto

A plugin for [Fisherman](https://github.com/jorgebucaran/fisher) version 4.

Requires a working `ruby` command on the system.

## Install

    fisher install carlosjhr64/pkg-goto

## Features

* Quickly change directory by `basename`.
* Runs `fish_greeting` on successfully going to the directory.

## Usage

    ~> goto [<pattern>+]

How `goto` actually filters your `HOME` directory listings
is by the following Ruby Regexp:

    pattern = ARGV.map{ it.gsub(".", "[.]") }.join(".*")
    regexp  = %r(#{pattern}/$)

The shortest length path of the filtered list is picked.
If any of the patterns contains a dot, hidden directories will be included.

If given a single pattern that can be interpreted as
an environment variable set to an existing path,
it'll `goto` that path.

# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
