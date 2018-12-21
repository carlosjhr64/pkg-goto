# pkg-goto

A plugin for [Fisherman](https://github.com/jorgebucaran/fisher) version v3.

## Install

    fisher add carlosjhr64/pkg-goto

## Features

* Quickly change directory by basename.
* Runs `fish_greeting` on succesfully going to the directory.

## Usage

    ~> goto <basename> [<basename>...]

In a nutshell, it's like running the following command:

    ~> cd (find ~/ -maxdepth 3 -type d -name "$argv[1]")

For directories deeper than depth 3, say ~/a/b/c/d/e/f, one can iterate down:

    ~>goto c f                           16:25:36
     # /home/user/a/b/c/d/f
    ~/a/b/c/d/f>                         16:25:38

If a given basename yields multiple directories,
`goto` will pick the first shallowest directory it finds.

# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
