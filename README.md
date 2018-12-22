# pkg-goto

A plugin for [Fisherman](https://github.com/jorgebucaran/fisher) version v3.

## Install

    fisher add carlosjhr64/pkg-goto

## Features

* Quickly change directory by basename.
* Runs `fish_greeting` on succesfully going to the directory.

## Usage

    ~> goto <basename> [<basename>...]

`goto` will search up to a depth of 4 for each basename.
If multiple listings is found on any step,
it'll filter out hidden directories and select the most recently modified directory.

# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
