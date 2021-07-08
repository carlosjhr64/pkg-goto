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

If no match is found for a basename, it'll check if it can be intepreted
as an enviroment variable, translate, and try again.
```shell
$ goto --trace .local nvim pack                                                                                            11:11:59
#/home/fox/.local/share/nvim/site/pack
$ pwd
/home/fox/.local/share/nvim/site/pack
$ echo $VIMDATA
/home/fox/.local/share/nvim
$ goto VIMDATA pack
$ pwd
/home/fox/.local/share/nvim/site/pack
```
# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
