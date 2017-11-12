# pkg-goto

A plugin for [Fisherman](http://fisherman.sh).

## Install

```fish
fisher install carlosjhr64/pkg-goto
```

## Features

* Quickly change directory by basename.
* Automatically switch themes by hidden `.theme` file.
* Runs `fish_greeting` on succesfully going to the directory.

## Usage

```fish
~> goto <basename> [<basename>...]
basename>
```

In a nutshell, it just runs the following command:

```fish
~> cd (find ~/ -maxdepth 3 -type d -name "$argv[1]")
```

For directories deeper than depth 3, say ~/a/b/c/d/e/f, one can iterate down:

```fish
~>goto c f                           16:25:36
 # /home/user/a/b/c/d/f
~/a/b/c/d/f>                         16:25:38
```

If a given basename yields multiple directories,
`goto` will pick the first shallowest directory it finds.

If `goto` finds a `.theme` file,
it sets the fisherman theme to that specified in the file
(unless already set to it).
It then runs `fish_greeting`.

# Screenshot

<p align="center">
<img src="goto.png">
</p>

# Version 0.2.0 vs. the previous version 0.1.0

The previous version just `cat .greeting` if a `.greeting` file was found, but
I decided that calling `fish_greeting` would be more universal and useful.

# Version 0.1.0 vs. the previous version 0.0.1

The previous version automated the PATH, RUBYLIB, and GOPATH maintainance, but
I decided that was giving `goto` to many responsibilities.

# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
